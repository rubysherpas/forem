module Forem
  # Defines a whole bunch of permissions for Forem
  # Access (most) areas by default
  module DefaultPermissions
    extend ActiveSupport::Concern

    included do
      unless method_defined?(:can_read_forem_category?)
        def can_read_forem_category?(category)
          true
        end
      end

      unless method_defined?(:can_read_forem_forums?)
        def can_read_forem_forums?
          true
        end
      end

      unless method_defined?(:can_read_forem_forum?)
        def can_read_forem_forum?(forum)
          return true if forum.allowed_viewers.empty?

          user = Forem.user_class.new

          p forum.allowed_viewers.first.members
          p user
          p forum.allowed_viewers.first.members.first == user

          has_user = forum.allowed_viewers.any? { |group| group.members.include? user }
          p has_user
          has_user
        end
      end

      unless method_defined?(:can_create_forem_topics?)
        def can_create_forem_topics?(forum)
          true
        end
      end

      unless method_defined?(:can_reply_to_forem_topic?)
        def can_reply_to_forem_topic?(topic)
          true
        end
      end

      unless method_defined?(:can_edit_forem_posts?)
        def can_edit_forem_posts?(forum)
          true
        end
      end

      unless method_defined?(:can_read_forem_topic?)
        def can_read_forem_topic?(topic)
          !topic.hidden? || forem_admin?
        end
      end

      unless method_defined?(:can_moderate_forem_forum?)
        def can_moderate_forem_forum?(forum)
          forum.moderator?(self)
        end
      end
    end
  end
end
