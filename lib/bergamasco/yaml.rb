module Bergamasco
  module Yaml
    # split file into YAML frontmatter and content
    YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m

    def self.split_yaml_frontmatter(file)
      metadata = SafeYAML.load(file)
      content = YAML_FRONT_MATTER_REGEXP.match(file).post_match
      [metadata, content]
    end
  end
end
