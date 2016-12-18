module Bergamasco
  module Markdown
    # split file into YAML frontmatter and content
    YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m

    def self.split_yaml_frontmatter(file)
      return file unless match = YAML_FRONT_MATTER_REGEXP.match(file)

      metadata = SafeYAML.load(file)
      content = match.post_match
      [metadata, content]
    end

    def self.update_yaml_frontmatter(metadata, new_metadata)
      metadata.merge(new_metadata).compact
    end

    def self.join_yaml_frontmatter(metadata, content)
      metadata.to_yaml + "---\n" + content
    end

    def self.update_file(file, new_metadata)
      metadata, content = split_yaml_frontmatter(file)
      metadata = update_yaml_frontmatter(metadata, new_metadata)
      join_yaml_frontmatter(metadata, content)
    end

    def self.read_yaml(filepath)
      unless File.exist?(filepath)
        parentdir = Pathname.new(filepath).parent
        FileUtils.mkdir_p parentdir
        FileUtils.touch filepath
      end

      file = IO.read(filepath)
      SafeYAML.load(file)
    end

    def self.read_yaml_for_doi_metadata(filepath, options={})
      keys = options[:keys] || ["title", "author", "date", "tags", "summary", "doi", "type", "version", "citation"]
      unless File.exist?(filepath)
        parentdir = Pathname.new(filepath).parent
        FileUtils.mkdir_p parentdir
        FileUtils.touch filepath
      end

      file = IO.read(filepath)
      yaml = SafeYAML.load(file)
      metadata = yaml.extract!(*keys).compact

      content = YAML_FRONT_MATTER_REGEXP.match(file).post_match
      html = render_html(content, options)
      metadata["summary"] = Bergamasco::Summarize.summary_from_html(html, options)
      metadata["citation"] = extract_references(html)
      metadata["date"] = metadata["date"].iso8601
      metadata
    end

    def self.write_yaml(filepath, content)
      IO.write(filepath, content.to_yaml)
    end

    def self.render_html(text, options={})
      PandocRuby.new(text, options.except(:skip_yaml_header, :separator)).to_html
    rescue Errno::ENOENT
      # fallback to commonmarker if pandoc is not installed.
      # Commonmarker doesn't parse or ignore yaml frontmatter
      text = split_yaml_frontmatter(text).last if options[:skip_yaml_header]
      CommonMarker.render_html(text, :default)
    end

    def self.write_bibliograpy_to_yaml(bib_path, yaml_path)
      yaml = `pandoc-citeproc --bib2yaml #{bib_path} 2>&1`
      return nil if $?.exitstatus > 0
      IO.write(yaml_path, yaml)
      SafeYAML.load(yaml)
    end

    # expects a references list generated by pandoc
    def self.extract_references(html)
      doc = Nokogiri::HTML(html)
      doc.xpath('//div[@id="refs"]/div/@id').map { |ref| ref.value[4..-1] }
    end
  end
end
