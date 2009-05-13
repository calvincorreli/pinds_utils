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
  end
end
