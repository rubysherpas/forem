module Forem
  module ForumsHelper
    def topics_count(forum)
      if forem_admin_or_moderator?(forum)
        forum.topics.count
      else
        forum.topics.approved.count
      end
    end

    def posts_count(forum)
      if forem_admin_or_moderator?(forum)
        forum.posts.count
      else
        forum.posts.approved.count
      end
    end

    def forums_title
      I18n.t('forem.page_title')
    end

    def forum_title
      I18n.t(
        'forem.forum.page_title',
        :forum => @forum.title,
        :category => @forum.category.name
      )
    end
  end
end
