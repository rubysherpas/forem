module Forem
  module Api
    module V1
      module JsonApiController
        extend ActiveSupport::Concern

        included do
          before_action { request.format = :json }

          before_action :client_generated_ids_are_unsupported, only: :create
          before_action :ids_cannot_be_updated, only: :update

          rescue_from ActionController::ParameterMissing, with: :bad_request,
            only: :create
          rescue_from CanCan::AccessDenied, with: :forbidden
        end

        private

        def authenticate_forem_user
          render nothing: true, status: :forbidden if !forem_user
        end

        def required_params
          params.require(:data).require(:attributes)
        end

        def create_successful
          render 'show', status: :created,
            location: resource_url
        end

        def create_failed
          render 'member_errors', status: :bad_request
        end
        alias_method :create_unsuccessful, :create_failed

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