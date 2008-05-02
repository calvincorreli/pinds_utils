module PindsUtils
  module UpdatedIpAndBy

    def self.included(target) #:nodoc:
      target.attr_protected :created_by, :updated_by, :created_at, :updated_at, :created_ip, :updated_ip, :controller
    end

    # Automatically set created_ip when setting updated_ip and it's a new record
    def updated_ip=(value)
      write_attribute(:updated_ip, value) if respond_to?(:updated_ip)
      write_attribute(:created_ip, value) if respond_to?(:created_ip) && created_ip.nil?
    end

    # Automatically set created_by when setting updated_by and it's a new record, and accept a User object
    def updated_by=(value)
      value = value.id if value.is_a?(User)
      write_attribute(:updated_by, value) if respond_to?(:updated_by)
      write_attribute(:created_by, value) if respond_to?(:created_by) && created_by.nil?
    end

    # Accept a User object
    def created_by=(value)
      value = value.id if value.is_a?(User)
      write_attribute(:created_by, value) if respond_to?(:created_by)
    end

    # Automatically get user_id, remote IP, and session id from controller
    def controller=(controller)
      return if controller.nil?
      @_controller = controller
      self.updated_ip = controller.request.remote_ip
      self.updated_by = controller.current_user.id if respond_to?(:updated_by=) && controller.respond_to?(:current_user) && controller.current_user 
      if new_record?
        self.session_id ||= controller.session.session_id if respond_to?(:session_id=) && controller.session.session_id
      end
    end
  end
end