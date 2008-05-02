module PindsUtils
  module Secret
    def self.included(target) #:nodoc:
      target.before_validation :set_secrets_before_validation
      target.extend(ClassMethods)
    end
    
    module ClassMethods
      def acts_as_secret(*args)
        args.flatten.each do |attr|
          attr_protected attr
          secret_attributes.concat([attr])
        end
      end
      
      def secret_attributes
        secret_attributes = read_inheritable_attribute(:secret_attributes)
        unless secret_attributes
          secret_attributes = []
          write_inheritable_attribute(:secret_attributes, secret_attributes)
        end
        secret_attributes
      end      
    end
    
    def generate_secret
      Digest::MD5.hexdigest(id.to_s + Time.now.to_f.to_s + rand().to_s) 
    end
    
    def reset_secrets(*args)
      (args || self.class.secret_attributes).each do |attr|
        self[attr] = generate_secret
      end
    end
    
    def set_secrets_before_validation
      self.class.secret_attributes.each do |attr|
        self[attr] = generate_secret if self[attr].blank?
      end
    end
  end
end