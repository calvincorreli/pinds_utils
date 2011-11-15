module PindsUtils
  require 'pinds_utils/view_helpers'
  require 'pinds_utils/enumeration'
  require 'pinds_utils/controller_utils'
  require 'pinds_utils/secret'
  require 'pinds_utils/updated_ip_and_by'
  require 'pinds_utils/string_ext'

  ActionController::Base.helper PindsUtils::ViewHelpers  
end
