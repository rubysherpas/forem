require_dependency "forem/application_controller"

module Forem
  module Api
    module V1
      class ForumsController < ApplicationController
        load_and_authorize_resource :class => 'Forem::Forum', :only => :show

        rescue_from CanCan::AccessDenied, with: :forbidden

        before_action { request.format = :json }

        private

        def forbidden
          render nothing: true, status: :forbidden
        end
      end
    end
  end
end
