module ::Forem
  class Engine < Rails::Engine
    isolate_namespace Forem

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end
    
    cattr_accessor :theme

    config.after_initialize do
      if defined?(::Refinery)
        # Allow forem to hook into Refinery CMS if it's available
        ::Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_forem"
          plugin.directory = "forem"
          plugin.url = '/forem/admin/forums'
          plugin.menu_match = /^\/?(admin|refinery)\/forem\/?(forums|posts|topics)?/
          plugin.activity = {
            :class => ::Forem::Post
          }
        end
      end
    end

    config.to_prepare do
      if defined?(::Refinery)
        ::Refinery::User.send :include, ::Forem::UserExtensions
      end
    end
  end
end

require 'simple_form'
