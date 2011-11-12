require 'forem/engine'
require 'kaminari'

module Forem
  extend ActiveSupport::Autoload
  autoload :DefaultPermissions

  mattr_accessor :user_class, :theme, :formatter

  class << self
    def user_class
      @@user_class || raise(ConfigurationNotFound.new("user_class"))
    end

    def user_class=(klass)
      @@user_class = klass
      if Class === klass
        klass.send :include, Forem::DefaultPermissions
      end
    end
  end

  class ConfigurationNotFound < StandardError
    attr_accessor :message
    def initialize(option)
      @message = "Forem configuration option #{option} not found. " +
        "Please set this in config/initializers/forem.rb with this line:\n\n" +
        "Forem.#{option}= <value>"
    end
  end

end
