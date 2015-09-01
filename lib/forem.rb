# Fix for #185 and build issues
require 'active_support/core_ext/kernel/singleton_class'

require 'forem/engine'
require 'forem/autocomplete'
require 'forem/default_permissions'
require 'forem/platform'
require 'forem/sanitizer'
require 'forem/state_workflow'
require 'sanitize'

require 'decorators'

module Forem
  mattr_accessor :base_path, :user_class, :formatter,
                 :default_gravatar, :default_gravatar_image, :avatar_user_method,
                 :user_profile_links, :email_from_address, :autocomplete_field,
                 :per_page, :sign_in_path, :moderate_first_post, :layout


  class << self
    def base_path
      @@base_path ||= Rails.application.routes.named_routes[:forem].path
    end

    def decorate_user_class!
      Forem.user_class.class_eval do
        extend Forem::Autocomplete
        include Forem::DefaultPermissions

        has_many :forem_posts, :class_name => "Forem::Post", :foreign_key => "user_id"
        has_many :forem_topics, :class_name => "Forem::Topic", :foreign_key => "user_id"
        has_many :forem_memberships, :class_name => "Forem::Membership", :foreign_key => "member_id"
        has_many :forem_groups, :through => :forem_memberships, :class_name => "Forem::Group", :source => :group

        def forem_moderate_posts?
          Forem.moderate_first_post && !forem_approved_to_post?
        end
        alias_method :forem_needs_moderation?, :forem_moderate_posts?

        def forem_approved_to_post?
          forem_state == 'approved'
        end

        def forem_spammer?
          forem_state == 'spam'
        end

        # Using +to_s+ by default for backwards compatibility
        def forem_name
          to_s
        end unless method_defined? :forem_name

        # Using +email+ by default for backwards compatibility. This attribute
        # it's optional
        def forem_email
          try :email
        end unless method_defined? :forem_email
      end
    end

    def moderate_first_post
      # Default it to true
      @@moderate_first_post != false
    end

    def autocomplete_field
      @@autocomplete_field || "email"
    end

    def per_page
      @@per_page || 20
    end

    def user_class
      if @@user_class.is_a?(Class)
        raise "You can no longer set Forem.user_class to be a class. Please use a string instead.\n\n " +
              "See https://github.com/radar/forem/issues/88 for more information."
      elsif @@user_class.is_a?(String)
        begin
          Object.const_get(@@user_class)
        rescue NameError
          @@user_class.constantize
        end
      end
    end

    def layout
      @@layout || "forem/default"
    end
  end
end
