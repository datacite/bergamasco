module Bergamasco
  module Sanitize
    ALLOWED_TAGS = Set.new(%w(strong em b i code pre sub sup br))

    def self.sanitize(text, options={})
      options[:tags] ||= ALLOWED_TAGS
      custom_scrubber = Bergamasco::WhitelistScrubber.new(options)

      Loofah.scrub_fragment(text, custom_scrubber).to_s
    end
  end
end
