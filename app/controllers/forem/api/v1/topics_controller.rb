require_dependency "forem/application_controller"

module Forem
  module Api
    module V1
      class TopicsController < Forem::TopicsController
        before_action { request.format = :json }

        protected

        def topic_params
          params.require(:data).require(:attributes).permit(:subject, :posts_attributes => [[:text]])
        end

        def create_successful
          render 'show', status: :created, location: api_forum_topic_url(@forum, @topic)
        end

        def create_unsuccessful
          raise 'TODO'
        end
      end
    end
  end
end
