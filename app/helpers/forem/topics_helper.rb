module Forem
  module TopicsHelper
    def link_to_latest_post(post)
      text = "#{time_ago_in_words(post.created_at)} #{t("ago_by")} #{post.user}"
      link_to text, forum_topic_path(post.topic.forum, post.topic, :anchor => "post-#{post.id}")
    end

    def new_since_last_view_text(topic)
      if forem_user
        if topic.new_for(forem_user)
          content_tag :super, "New"
        end
      end
    end
  end
end
