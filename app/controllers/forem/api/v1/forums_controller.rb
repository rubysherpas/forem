require_dependency "forem/application_controller"

module Forem
  module Api
    module V1
      class ForumsController < Forem::ForumsController
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
