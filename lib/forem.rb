require "forem/engine"
require "forem/kaminari_config"
require 'rdiscount'

module Forem

  mattr_accessor :user_class

  class << self
    def user_class
      @@user_class || raise(ConfigurationNotFound.new("user_class"))
    end
  end
  
  class ConfigurationNotFound < StandardError
    attr_accessor :message
    def initialize(option)
      @message = "Forem configuration option #{option} not found. " + 
        "Please set this in config/initializers/forem.rb."
    end
  end

end
