require "forem/engine"
require "forem/user_extensions"
module Forem

  mattr_accessor :user_name, :current_user, :login_url

  class << self
    def user_name
      @@user_name || raise(ConfigurationNotFound.new("user_name"))
    end

    def current_user
      @@current_user || raise(ConfigurationNotFound.new("current_user"))
    end

    def login_url
      @@login_url || raise(ConfigurationNotFound.new("login_url"))
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
