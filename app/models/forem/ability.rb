require 'cancan'

module Forem
  class Ability
    include CanCan::Ability

    def initialize(user)
      # TODO: Discover why we have to do this.
      # It appears that whatever's passing through the object is using
      # a cached version of the User class
      user = if user
        Forem.user_class.find(user.id)
      else
        Forem.user_class.new # anonymous user
      end

      can :read, Forem::Category do |category|
        user.can_read_forem_category?(category)
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

      can :edit, :all if user.can_edit_forem_posts?
      
    end
  end
end
