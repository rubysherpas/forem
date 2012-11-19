module Forem
  # Defines a whole bunch of permissions for Forem
  # Access (most) areas by default
  module DefaultPermissions
    extend ActiveSupport::Concern

    included do
      unless method_defined?(:can_read_forem_category?)
        def can_read_forem_category?(category)
          return false unless accepted_terms?
          return true if forem_admin? || forem_mod? || category.forem_public?
          name = category.name
          forem_groups.each do |g|
            return true if g.name == name || g.name == name + Forem::Group::ADMIN_POSTFIX
          end

          false
        end
      end

      unless method_defined?(:can_read_forem_forums?)
        def can_read_forem_forums?
          true
        end
      end

      unless method_defined?(:can_read_forem_forum?)
        def can_read_forem_forum?(forum)
          true
        end
      end

      unless method_defined?(:can_create_forem_topics?)
        def can_create_forem_topics?(forum)
          return true if forem_admin? || forem_mod? || forum.moderator?(self)
          !forum.forem_protected?
        end
      end

      unless method_defined?(:can_reply_to_forem_topic?)
        def can_reply_to_forem_topic?(topic)
          true
        end
      end

      unless method_defined?(:can_edit_forem_posts?)
        def can_edit_forem_posts?(forum)
          return true if forem_admin? || forem_mod?
          false
        end
      end

      unless method_defined?(:can_read_forem_topic?)
        def can_read_forem_topic?(topic)
          !topic.hidden? || forem_admin? || forem_mod?
        end
      end

      unless method_defined?(:can_moderate_forem_forum?)
        def can_moderate_forem_forum?(forum)
          return true if forum.moderator?(self) || forem_mod? || forem_admin?
          forem_groups.each do |g|
            return true if g.name == forum.category.name + Forem::Group::ADMIN_POSTFIX
          end

          false
        end
      end
      
      unless method_defined?(:can_moderate_forem_topics?)
        def can_moderate_forem_topic?(topic)
          return true if forem_admin? || forem_mod?
          forem_groups.each do |g|
            return true if g.name == topic.forum.category.name + Forem::Group::ADMIN_POSTFIX
          end

          false
        end
      end
      
      unless method_defined?(:check_permissions)
        def check_permissions(name)
          return true if forem_admin? || forem_mod?
          forem_groups.each do |g|
            return true if g.name == name || g.name == name + Forem::Group::ADMIN_POSTFIX
          end

          false
        end
      end
    end
  end
end
