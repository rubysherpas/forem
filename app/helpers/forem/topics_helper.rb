module Forem
  module TopicsHelper
    def link_to_latest_post(topic, user)
      post = relevant_posts(topic, user).last
      text = "#{time_ago_in_words(post.created_at)} #{t("ago_by")} #{post.user}"
      link_to text, forem.forum_topic_path(post.topic.forum, post.topic, :anchor => "post-#{post.id}", :page => topic.last_page)
    end

    def new_since_last_view_text(topic, user)
      if user
        topic_view = topic.view_for(user)
        forum_view = topic.forum.view_for(user)

        if forum_view && topic_view.nil? && topic.created_at > forum_view.past_viewed_at
          content_tag :super, "New"
        end
      end
    end

    def relevant_posts(topic, user)
      posts = topic.posts.by_created_at.scoped
      return posts if forem_admin_or_moderator?(topic.forum)

      if topic.user == user
        posts.visible.approved_or_pending_review_for(topic.user)
      else
        posts.approved
      end
    end

    def new_posts?(topic, user)
      view = (topic.view_for(user) if user)
      view && topic.posts.exists?(["created_at > ?", view.updated_at])
    end

    def topic_delete_link(topic, user)
      if topic.user == user || forem_admin?
        link_to t('delete', :scope => 'forem.topics.show'),
                forem.forum_topic_path(topic.forum, topic),
                :method => :delete, :data => { :confirm => t("are_you_sure") }
      end
    end

    def topic_reply_link(topic, user)
      if topic.can_be_replied_to? && can?(:reply, topic)
        link_to t("reply", :scope => 'forem.topics.show'),
                forem.new_topic_post_path(topic)
      end
    end

  end
end
