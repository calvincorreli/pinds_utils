module PindsUtils
  module ViewHelpers
    def onload(javascript)
      javascript_tag "Event.observe(window, 'load', function() { #{javascript} })"
    end

    def focus(options = {})
      if options[:id]
        javascript_tag("document.observe('dom:loaded', function() { $('#{options[:id]}').focus(); })")
      elsif options[:form]
        javascript_tag("Form.focusFirstElement('#{options[:form]}')")
      end
    end
    
    def open_tag(name, options)
      tag(name, options, true)
    end

    def hide_if(condition)
      condition ? "display: none" : ""
    end
    
    # Needed by error_message_on and error_messages_for to make them accept object instead of object name
    def object_from_name_or_object(object)
      case object
      when String, Symbol: instance_variable_get("@#{object}") 
      else object
      end
    end

    # Accept object instead of object name
    def error_message_on(object, method, prepend_text = "", append_text = "", css_class = "formError")
      if (obj = object_from_name_or_object(object)) && (errors = obj.errors.on(method))
        content_tag("div", "#{prepend_text}#{errors.is_a?(Array) ? errors.first : errors}#{append_text}", :class => css_class)
      end
    end

    # Accept object instead of object name
    def error_messages_for(*params)
      options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
      objects = params.collect { |object| object_from_name_or_object(object) }.compact
      count   = objects.inject(0) {|sum, object| sum + object.errors.count }
      unless count.zero?
        html = {}
        [:id, :class].each do |key|
          if options.include?(key)
            value = options[key]
            html[key] = value unless value.blank?
          else
            html[key] = 'errorExplanation'
          end
        end
        header_message = "#{pluralize(count, 'error')} prohibited this #{(options[:object_name] || objects.first.class.name.gsub('_', ' ').downcase)} from being saved"
        error_messages = objects.map {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg) } }
        content_tag(:div,
          content_tag(options[:header_tag] || :h2, header_message) <<
            content_tag(:p, 'There were problems with the following fields:') <<
            content_tag(:ul, error_messages),
          html
        )
      else
        ''
      end
    end
  end
end
