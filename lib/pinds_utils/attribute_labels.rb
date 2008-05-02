module PindsUtils
  module AttributeLabels    
    def self.included(target) #:nodoc:
      target.extend(ClassMethods)
    end
    
    module ClassMethods
      def method_name_for_attribute_label(attribute_key_name)
        "human_attribute_name_for_#{attribute_key_name}"
      end

      def set_attribute_label(*args)
        case args.first
        when Hash:
          args.first.each { |key, value| set_attribute_label key, value }
        else
          attribute_key_name, value = args
          sing = class << self; self; end
          name = method_name_for_attribute_label(attribute_key_name)
          sing.class_eval "def #{name}; #{value.to_s.inspect}; end"
        end
      end

      def human_attribute_name(attribute_key_name)
        name = method_name_for_attribute_label(attribute_key_name)
        respond_to?(name) ? send(name) : attribute_key_name.to_s.humanize
      end
    end
  end
end