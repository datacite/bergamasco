module Bergamasco
  module Pandoc
    # Options understood by pandoc, taken from http://pandoc.org/MANUAL.html.
    # Ignore all other options passed to pandoc, unless overriden.
    AVAILABLE_OPTIONS = Set.new %w(from read to write output data-dir strict
      parse-raw smart old-dashes base-header-level indented-code-classes filter
      normalize preserve-tabs tab-stop track-changes file-scope extract-media
      standalone template metadata variable print-default-template
      print-default-data-file no-wrap wrap columns toc table-of-contents toc-depth
      no-highlight highlight-style include-in-header include-before-body
      include-after-body self-contained offline html5 html-q-tags ascii
      reference-links reference-location atx-headers chapters top-level-division
      number-sections number-offsetS no-tex-ligatures listings incremental
      slide-level section-divs default-image-extension email-obfuscation id-prefix
      title-prefix css reference-odt reference-docx epub-stylesheet
      epub-cover-image epub-metadata epub-embed-font epub-chapter-level
      latex-engine latex-engine-opt bibliography csl citation-abbreviations natbib
      biblatex latexmathml asciimathml mathml mimetex webtex jsmath mathjax katex
      katex-stylesheet gladtex trace dump-args ignore-args verbose bash-completion
      list-input-formats list-output-formats list-extensions
      list-highlight-languages list-highlight-styles)
    ALIAS_OPTIONS = Set.new %w(f r t w o R S F p s M V D H B A 5 N i T c m)
    ALLOWED_OPTIONS = AVAILABLE_OPTIONS + ALIAS_OPTIONS

    def self.convert(text, options={})
      options = options.select { |k, v| ALLOWED_OPTIONS.include?(k.to_s.gsub('_', '-')) }.to_h

      options[:from] ||= :markdown
      options[:to] ||= :html

      PandocRuby.convert(text, options)
    rescue Errno::ENOENT
      puts "Pandoc is not installed"
    end

    def self.convert_to_jats(text, options={})
      template = File.expand_path("../../../templates/default.jats", __FILE__)
      to = File.expand_path("../jats.lua", __FILE__)
      csl = File.expand_path("../jats.csl", __FILE__)

      options = options.merge(template: template, to: to, csl: csl)
      options = options.merge(metadata: options[:metadata]) if options[:metadata].present?

      convert(text, options)
    end

    def self.write_jats(input_path, output_path, options={})
      file = IO.read(input_path)
      xml = convert_to_jats(file, options)
      IO.write(output_path, xml)
      output_path
    end

    def self.write_bibliograpy_to_yaml(bib_path, yaml_path)
      yaml = `pandoc-citeproc --bib2yaml #{bib_path} 2>&1`
      return nil if $?.exitstatus > 0
      IO.write(yaml_path, yaml)
      SafeYAML.load(yaml)
    end
  end
end
