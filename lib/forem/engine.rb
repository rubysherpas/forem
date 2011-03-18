module Forem
  class Engine < Rails::Engine
    isolate_namespace Forem

    initializer "serve static assets" do |app|
      app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
    end

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    config.after_initialize do
      # Allow forem to hook into Refinery CMS if it's available
      ::Refinery::Plugin.register do |plugin|
        plugin.name = "forem"
        plugin.directory = "forem"
        plugin.url = {:controller => '/admin/forem/forums', :action => 'index'}
        plugin.menu_match = /^\/?(admin|refinery)\/forem\/?(forums|posts|topics)?/
        plugin.activity = {
          :class => ::Forem::Post
        }
      end if defined?(::Refinery)
    end

  end
end

require 'simple_form'

# Fixes this error:
# Encoding::CompatibilityError:
#        incompatible encoding regexp match (UTF-8 regexp with ASCII-8BIT string)
# Which happens when running integration specs containing a form
require 'rack/utils_monkey_patch'