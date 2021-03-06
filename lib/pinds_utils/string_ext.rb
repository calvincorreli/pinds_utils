# encoding: UTF-8

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
      
      # Make available to the String methods below
      module_function :pluralize, :truncate, :textilize                      
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
    result.gsub!(/[æÆ]/, 'ae')
    result.gsub!(/[øØ]/, 'oe')
    result.gsub!(/[åÅ]/, 'aa')

    # Handle accented chars (is there a standardized way to do this?)
    result.gsub!(/[áäÁÄ]/, 'a')
    result.gsub!(/[éëÉË]/, 'e')

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


