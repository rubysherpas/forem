require 'cancan'

module Forem
  class Ability
    include CanCan::Ability

    def initialize(user)

      user ||= User.new # anonymous user

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
    end
  end
end
