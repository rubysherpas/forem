module Forem
  module TopicsHelper
    def link_to_latest_post(post)
      text = "#{time_ago_in_words(post.created_at)} #{t("ago_by")} #{post.user}"
      link_to text, forum_topic_path(post.topic.forum, post.topic, :anchor => "post-#{post.id}")
    end

    def new_since_last_view_text(topic)
      if forem_user
        # hasn't been viewed and was created within 15 minutes of last forum view
        topic_view = topic.view_for(forem_user)
        forum_view = topic.forum.view_for(forem_user)

        if forum_view
          if topic_view.nil? && (topic.created_at - forum_view.viewed_at) < 15.minutes
            content_tag :super, "New"
          end
        end
      end
    end
  end
end
