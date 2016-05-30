require_dependency "forem/application_controller"

module Forem
  module Api
    module V1
      class PostsController < Forem::PostsController
        include JsonApiController

        protected

        def post_params
          required_params.permit(:text)
        end

        def resource_url
          api_forum_topic_post_url(@topic.forum, @topic, @post)
        end
      end
    end
  end
end
