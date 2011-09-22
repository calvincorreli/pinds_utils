module ActionView
  module Helpers
    module TextHelper
      # From Typo
      def nofollowify(text)
        text.gsub(/<\s*a\s*(.+?)>/i, '<a \1 rel="nofollow">')
      end

      def textilize(text)
        RedCloth.new(text.to_s).to_html.gsub( /(.)\n(?!\Z| *([#*=]+(\s|$)|[{|]))/, "\\1<br />" ).gsub(%r{</p><br />}, '</p>')
      end
      
      def comment_to_html(body)
        nofollowify(sanitize(textilize(auto_link(body.dup).gsub(%r|(>https?://)(\S{50,50})(\S*)(<)|, '\1\2&hellip;\4'))))
      end

      # Make available to the String methods below
      module_function :pluralize, :truncate, :nofollowify, :auto_link, :textilize, 
                      :auto_link_email_addresses, :auto_link_urls
      module_function :strip_links, :sanitize rescue nil
    end

    module SanitizeHelper
      module_function :strip_links, :sanitize rescue nil
    end
  end
end

class String
  unless method_defined?(:truncate)
    def truncate(length = 30, truncate_string = "...")
      ActionView::Helpers::TextHelper.truncate(self, :length => length, :omission => truncate_string)
    end
  end
  
  unless method_defined?(:pluralize)
    def pluralize(count = nil, plural = nil)
      count == 1 ? self : (plural || ActiveSupport::Inflector.pluralize(self))
    end
  end
  
  def strip_links
    ActionView::Helpers::SanitizeHelper.strip_links(self) rescue ActionView::Helpers::TextHelper.strip_links(self)
  end
  
  def unsmartify
    self.gsub(/’/, "'").gsub(/“/, '"').gsub(/”/, '"').gsub(/–/, "-").gsub(/…/, "...")
  end

  # From Typo:
  # Converts a post title to its-title-using-dashes
  # All special chars are stripped in the process  
  #
  # options:
  #   :maxlen    - max length of the resulting string
  #   :keep_case - don't downcase the string
  def to_url(options = {})
    if options.is_a?(Fixnum)
      maxlen = options
      options = {}
    else
      maxlen = options[:maxlen]
    end
    
    result = self.strip
    result.downcase! unless options[:keep_case]

    # replace quotes by nothing
    result.gsub!(/['"]/, '')

    # Handle Danish chars
    result.gsub!(/æ/, 'ae')
    result.gsub!(/ø/, 'oe')
    result.gsub!(/å/, 'aa')
    result.gsub!(/Æ/, 'AE')
    result.gsub!(/Ø/, 'OE')
    result.gsub!(/Å/, 'AA')
    
    # Handle accented chars (is there a standardized way to do this?)
    result.gsub!(/[áä]/, 'a')
    result.gsub!(/[éë]/, 'e')
    result.gsub!(/[ÁÄ]/, 'A')
    result.gsub!(/[ÉË]/, 'E')

    # strip all non word chars
    result.gsub!(/[^a-zA-Z0-9_-]/, ' ')

    # replace all white space sections with a hyphen
    result.gsub!(/\ +/, '-')

    # trim hyphens
    result.gsub!(/(--+)/, '-')

    if maxlen && result.length > maxlen
      result = result[0..maxlen]
      result = result[0...maxlen] unless result.gsub!(/(.+)(-[^-]*)$/, '\1')
    end 

    result.gsub!(/(-)$/, '')
    result.gsub!(/^(-)/, '')

    result
  end

  def flush_left
    indt = 0
    text = self.gsub(/\t/, '  ')
    if text =~ /^ /
      while text !~ /^ {#{indt}}\S/
        indt += 1
      end unless text.empty?
      if indt.nonzero?
        text.gsub!( /^ {#{indt}}/, '' )
      end
    end
    text
  end
end


