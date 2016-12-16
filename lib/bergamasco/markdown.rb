module Bergamasco
  module Markdown
    # split file into YAML frontmatter and content
    YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m

    def self.split_yaml_frontmatter(file)
      metadata = SafeYAML.load(file)
      content = YAML_FRONT_MATTER_REGEXP.match(file).post_match
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
      file = IO.read(filepath)
      SafeYAML.load(file)
    end

    def self.write_yaml(filepath, content)
      unless File.exist?(filepath)
        parentdir = Pathname.new(filepath).parent
        FileUtils.mkdir_p parentdir
        FileUtils.touch filepath
      end

      IO.write(filepath, content.to_yaml)
    end

    def self.render_html(text, options={})
      text = split_yaml_frontmatter(text).last if options[:skip_yaml_header]

      CommonMarker.render_html(text, :default)
    end
  end
end
