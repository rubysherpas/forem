require 'cancan'

module Forem
  class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= User.new # anonymous user

      if user.can_read_forums?
        can :read, Forem::Forum
      end

      can :read, :forums
    end
  end
end
