# Fix for #185 and build issues
require 'active_support/core_ext/kernel/singleton_class'

require 'forem/engine'
require 'forem/autocomplete'
require 'forem/default_permissions'
require 'workflow'

module Forem
  mattr_accessor :user_class, :theme, :formatter, :default_gravatar, :default_gravatar_image,
                 :user_profile_links, :email_from_address, :autocomplete_field,
                 :avatar_user_method, :per_page, :sign_in_path, :moderate_first_post


  class << self
    def moderate_first_post
      # Default it to true
      @@moderate_first_post == false ? false : true
    end

    def autocomplete_field
      @@autocomplete_field || "email"
    end

    def per_page
      @@per_page || 20
    end

    def user_class=(obj)
      @@user_class = obj.to_s
    end

    def user_class
      Object.const_get(@@user_class)
    end

    # Method to work around problem defined in #329
    # Used by associations
    def user_class_string
      "::" + user_class.to_s
    end
  end
end
