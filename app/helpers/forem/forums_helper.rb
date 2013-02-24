module Forem
  module ForumsHelper
    def topics_count(forum)
      if forem_admin_or_moderator?(forum)
        forum.topics_count
      else
        forum.topics_approved_count
      end
    end

    def posts_count(forum)
      if forem_admin_or_moderator?(forum)
        forum.posts.count
      else
        forum.posts.approved.count
      end
    end
  end
end
