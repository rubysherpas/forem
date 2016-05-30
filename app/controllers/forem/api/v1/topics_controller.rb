require_dependency "forem/application_controller"

module Forem
  module Api
    module V1
      class TopicsController < Forem::TopicsController
        include JsonApiController

        private

        def topic_params
          required_params.permit(:subject)
        end

        def resource_url
          api_forum_topic_url(@forum, @topic)
        end

        def topic_not_found
          render nothing: true, status: :not_found
        end
      end
    end
  end
end
