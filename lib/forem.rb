require 'forem/engine'
require 'redcarpet'
require 'kaminari'

module Forem

  mattr_accessor :user_class, :theme, :markdown

  class << self
    def markdown
      @@markdown ||= ::Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    end

    def user_class
      @@user_class || raise(ConfigurationNotFound.new("user_class"))
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
