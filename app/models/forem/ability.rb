require 'cancan'

module Forem
  module Ability
    include CanCan::Ability

    def self.included(target)
      target.class_eval do
        # Alias old class's initialize so we can get it to after
        # Otherwise initialize attempts to go to an initialize that doesn't take an arg
        alias_method :old_initialize, :initialize

        def initialize(user)
          # Let other permissions run before this
          old_initialize(user)

          user ||= User.new # anonymous user

          if user.can_read_forem_forums?
            can :read, Forem::Forum do |forum|
              user.can_read_forem_forum?(forum)
            end
          end
        end
      end

      can :read, :forums
    end
  end
end
