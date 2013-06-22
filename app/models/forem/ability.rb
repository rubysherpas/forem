require 'cancan/ability'

module Forem
  class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= Forem.user_class.new

      can :read, Forem::Category
      can :read, Forem::Topic
      can :read, Forem::Forum
      can :create_topic, Forem::Forum
      can :reply, Forem::Topic
      can :edit_post, Forem::Forum
      can :moderate, Forem::Forum
    end
  end
end
