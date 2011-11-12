module ::Forem
  class Engine < Rails::Engine
    isolate_namespace Forem

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    config.after_initialize do
      # Add Forem::Ability to whatever Ability class is defined.
      # Could be Forem's (app/models/ability.rb) or could be application's.
      ::Ability.send :include, Forem::Ability
    end
  end
end

require 'simple_form'
