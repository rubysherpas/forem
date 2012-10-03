module ::Forem
  class Engine < Rails::Engine
    isolate_namespace Forem

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end

      # Fix for #88
      if Forem.user_class
        Forem.user_class.send :extend, Forem::Autocomplete

        Forem.user_class.send :include, Forem::DefaultPermissions

        Forem.user_class.has_many :forem_posts, :class_name => "Forem::Post", :foreign_key => "user_id"
        Forem.user_class.has_many :forem_topics, :class_name => "Forem::Topic", :foreign_key => "user_id"
        Forem.user_class.has_many :forem_memberships, :class_name => "Forem::Membership", :foreign_key => "member_id"
        Forem.user_class.has_many :forem_groups, :through => :forem_memberships, :class_name => "Forem::Group", :source => :group
      end

      # add forem helpers to main application
      ::ApplicationController.send :helper, Forem::Engine.helpers

    end

    # Precompile any assets included straight in certain pges
    initializer "forem.assets.precompile", :group => :all do |app|
      app.config.assets.precompile += %w[
        forem/admin/members.js
      ]
    end
  end
end

require 'simple_form'
require 'emoji/railtie'

# We need one of the two pagination engines loaded by this point.
# We don't care which one, just one of them will do.
begin
  require 'kaminari'
rescue LoadError
  begin
    require 'will_paginate'
  rescue LoadError
   puts "Please add the kaminari or will_paginate gem to your application's Gemfile. The Forem engine needs either kaminari or will_paginate in order to paginate."
   exit
  end
end
