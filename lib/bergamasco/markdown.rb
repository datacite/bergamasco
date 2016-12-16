module Bergamasco
  module Markdown
    # split file into YAML frontmatter and content
    YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m

    def self.split_yaml_frontmatter(file)
      metadata = SafeYAML.load(file)
      content = YAML_FRONT_MATTER_REGEXP.match(file).post_match
      [metadata, content]
    end

    def self.render_html(text, options={})
      text = split_yaml_frontmatter(text).last if options[:skip_yaml_header]

      CommonMarker.render_html(text, :default)
    end
  end
end
