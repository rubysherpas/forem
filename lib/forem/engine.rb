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
      end
    end
  end
end

require 'simple_form'
