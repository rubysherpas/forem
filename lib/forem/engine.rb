module ::Forem
  class Engine < Rails::Engine
    isolate_namespace Forem

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    # Fix for #88
    config.to_prepare do
      if Forem.user_class
        Forem.user_class.send :extend, Forem::Autocomplete

        Forem.user_class.send :include, Forem::DefaultPermissions

        Forem.user_class.has_many :forem_posts, :class_name => "Forem::Post", :foreign_key => "user_id"
        Forem.user_class.has_many :forem_topics, :class_name => "Forem::Topic", :foreign_key => "user_id"
        Forem.user_class.has_many :forem_memberships, :class_name => "Forem::Membership", :foreign_key => "member_id"
        Forem.user_class.has_many :forem_groups, :through => :forem_memberships, :class_name => "Forem::Group", :source => :group
      end
    end
  end
end

require 'simple_form'
