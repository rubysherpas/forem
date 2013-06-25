module Forem
  module Admin
    module ForumsHelper
      def forem_forum_topic_links(topic, forum)
        links = ActiveSupport::SafeBuffer.new
        if !topic.try(:new_record?) && can?(:create_topic, forum)
          links << link_to(t('forem.topic.links.new'), forem.new_forum_topic_path(forum))
        end
        links << link_to(t('forem.topic.links.back_to_topics'), forem.forum_path(forum)) if topic
        if can?(:moderate, forum)
          links << link_to(t('forem.forum.moderator_tools'), forem.forum_moderator_tools_path(forum))
        end
        links
      end
    end
  end
end
