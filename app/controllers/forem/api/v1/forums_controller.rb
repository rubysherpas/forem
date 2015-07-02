require_dependency "forem/application_controller"

module Forem
  module Api
    module V1
      class ForumsController < ApplicationController
        load_and_authorize_resource :class => 'Forem::Forum', :only => :show

        before_action { request.format = :json }
      end
    end
  end
end
