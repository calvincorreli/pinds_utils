module PindsUtils
  module ControllerUtils
    def modified_since?(modified_date)
      modified = true
      if since = request.env['If-Modified-Since']
        begin
          since = Time.httpdate(since) rescue Time.parse(since)
          modified = (since < modified_date)
        rescue Exception
        end
      end
      render(:nothing => true, :status => 304) unless modified 
      return modified
    end
    
    def pluralize(count, singular, plural = nil)
       "#{count || 0} " + if count == 1 || count == '1'
        singular
      elsif plural
        plural
      elsif Object.const_defined?("ActiveSupport::Inflector")
        ActiveSupport::Inflector.pluralize(singular)
      else
        singular + "s"
      end
    end    
  end
end