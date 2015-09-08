module Forem
  module ControllerHacks
    def use_forem_routes
      routes { Forem::Engine.routes }
    end
  end
end

RSpec.configure do |c|
  c.extend Forem::ControllerHacks, :type => :controller
end

