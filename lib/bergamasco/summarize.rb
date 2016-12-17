module Bergamasco
  module Summarize
    # based on from https://github.com/middleman/middleman-blog/blob/master/lib/middleman-blog/blog_article.rb
    def self.summary(text, options={})
      if options[:separator]
        truncate_at_separator(text, options[:separator])
      else
        max_length = options[:length] || 250
        ellipsis = options[:ellipsis] || "..."
        truncate_at_length(text, max_length, ellipsis)
      end
    end

    def self.summary_from_html(html, options={})
      summary = Bergamasco::Sanitize.sanitize(html, options).squish
      summary(summary, options)
    end

    # from https://github.com/middleman/middleman-blog/blob/master/lib/middleman-blog/truncate_html.rb
    def self.truncate_at_separator(text, separator)
      text = text.encode('UTF-8') if text.respond_to?(:encode)
      doc = Nokogiri::HTML::DocumentFragment.parse text.split(separator).first
      doc.inner_html
    end

    # from https://github.com/middleman/middleman-blog/blob/master/lib/middleman-blog/truncate_html.rb
    def self.truncate_at_length(text, max_length, ellipsis = "...")
      ellipsis_length = ellipsis.length
      text = text.encode('UTF-8') if text.respond_to?(:encode)
      doc = Nokogiri::HTML::DocumentFragment.parse text
      content_length = doc.inner_text.length
      actual_length = max_length - ellipsis_length
      if content_length > actual_length
        doc.truncate(actual_length, ellipsis).inner_html
      else
        text
      end
    end
  end
end

# from https://github.com/middleman/middleman-blog/blob/master/lib/middleman-blog/truncate_html.rb
module NokogiriTruncator
  module NodeWithChildren
    def truncate(max_length, ellipsis)
      return self if inner_text.length <= max_length
      truncated_node = self.dup
      truncated_node.children.remove

      self.children.each do |node|
        remaining_length = max_length - truncated_node.inner_text.length
        break if remaining_length <= 0
        truncated_node.add_child node.truncate(remaining_length, ellipsis)
      end
      truncated_node
    end
  end

  module TextNode
    def truncate(max_length, ellipsis)
      # Don't break in the middle of a word
      trimmed_content = content.match(/(.{1,#{max_length}}[\w]*)/m).to_s
      trimmed_content << ellipsis if trimmed_content.length < content.length

      Nokogiri::XML::Text.new(trimmed_content, parent)
    end
  end

  module CommentNode
    def truncate(*args)
      # Don't truncate comments, since they aren't visible
      self
    end
  end
end

Nokogiri::HTML::DocumentFragment.send(:include, NokogiriTruncator::NodeWithChildren)
Nokogiri::XML::Element.send(:include, NokogiriTruncator::NodeWithChildren)
Nokogiri::XML::Text.send(:include, NokogiriTruncator::TextNode)
Nokogiri::XML::Comment.send(:include, NokogiriTruncator::CommentNode)
