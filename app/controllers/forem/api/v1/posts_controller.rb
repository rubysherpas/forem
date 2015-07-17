require_dependency "forem/application_controller"

module Forem
  module Api
    module V1
      class PostsController < Forem::PostsController
        before_action { request.format = :json }

        before_action :client_generated_ids_are_unsupported, only: :create
        before_action :ids_cannot_be_updated, only: :update

        rescue_from ActionController::ParameterMissing, with: :bad_request,
          only: :create
        rescue_from CanCan::AccessDenied, with: :forbidden

        protected

        def authenticate_forem_user
          render nothing: true, status: :forbidden if !forem_user
        end

        def post_params
          params.require(:data).require(:attributes).permit(:text, :reply_to_id)
        end

        def create_successful
          render 'show', status: :created,
            location: api_forum_topic_post_url(@topic.forum, @topic, @post)
        end

        def create_failed
          render 'member_errors', status: :bad_request
        end

        def update_successful
          render 'show', status: :ok
        end

        def update_failed
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

        def ids_cannot_be_updated
          if params[:data][:id] != @post.id
            render nothing: true, status: :conflict if params[:data][:id]
          end
        end
      end
    end
  end
end
