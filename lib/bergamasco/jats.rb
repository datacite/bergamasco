module Bergamasco
  module Jats

    def self.render_jats(text, options={})
      options = options.merge(template: "templates/default.jats",
                              to: "lib/bergamasco/jats.lua",
                              csl: "lib/bergamasco/jats.csl")
      options = options.merge(metadata: options[:metadata]) if options[:metadata].present?
      converter = PandocRuby.new(text, options.except(:skip_yaml_header,
                                                      :separator,
                                                      :sitepath,
                                                      :authorpath,
                                                      :referencespath,
                                                      :username,
                                                      :password,
                                                      :sandbox,
                                                      :prefix))
      converter.convert
    rescue Errno::ENOENT
      # if pandoc is not installed.
      puts "Pandoc is not installed"
    end

    def self.write_jats(filepath, options={})
      file = IO.read(filepath)
      xml_path = File.join(File.dirname(filepath), File.basename(filepath, ".html.md")) + ".xml"
      xml = render_jats(file, options)
      IO.write(xml_path, xml)
      xml_path
    end
  end
end
