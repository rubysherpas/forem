require 'cancan'

module Forem
  class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= Forem.user_class.new

      can :read, Forem::Category do |category|
        user.can_read_forem_category?(category)
      end

      can :read, Forem::Topic do |topic|
        user.can_read_forem_forum?(topic.forum) && user.can_read_forem_topic?(topic)
      end

      if user.can_read_forem_forums?
        can :read, Forem::Forum do |forum|
          user.can_read_forem_category?(forum.category) && user.can_read_forem_forum?(forum)
        end
      end

      can :create_topic, Forem::Forum do |forum|
        can?(:read, forum) && user.can_create_forem_topics?(forum)
      end

      can :reply, Forem::Topic do |topic|
        user.can_reply_to_forem_topic?(topic)
      end

      can :edit_post, Forem::Forum do |forum|
        user.can_edit_forem_posts?(forum)
      end
    end
  end
end
