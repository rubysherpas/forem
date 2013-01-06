# Public: A collection of helper methods which detect the current
# running platform
module Forem
  module Platform

    def self.ruby_engine
      RUBY_ENGINE rescue "ruby"
    end

    def self.mri?
      ruby_engine == "ruby"
    end

    def self.jruby?
      ruby_engine == "jruby"
    end

  end
end
