require_dependency "forem/application_controller"

module Forem
  module Api
    module V1
      class TopicsController < Forem::TopicsController
        before_action { request.format = :json }

        before_filter :client_generated_ids_are_unsupported

        rescue_from ActionController::ParameterMissing, with: :bad_request
        rescue_from CanCan::AccessDenied, with: :forbidden

        protected

        def authenticate_forem_user
          render nothing: true, status: :forbidden if !forem_user
        end

        def topic_params
          params.require(:data).require(:attributes).permit(:subject, :posts_attributes => [[:text]])
        end

        def create_successful
          render 'show', status: :created, location: api_forum_topic_url(@forum, @topic)
        end

        def create_unsuccessful
          render 'member_errors', status: :bad_request
        end

        def bad_request
          render nothing: true, status: :bad_request
        end

        def forbidden
          render nothing: true, status: :forbidden
        end

        def client_generated_ids_are_unsupported
          render nothing: true, status: :forbidden if params[:data][:id]
        end
      end
    end
  end
end
