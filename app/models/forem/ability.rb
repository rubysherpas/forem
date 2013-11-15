require 'cancan'

module Forem
  class Ability
    include CanCan::Ability

    class_attribute :abilities
    self.abilities = Set.new

    # Allows us to go beyond the standard cancan initialize method which makes it difficult for engines to
    # modify the default +Ability+ of an application.  The +ability+ argument must be a class that includes
    # the +CanCan::Ability+ module.  The registered ability should behave properly as a stand-alone class
    # and therefore should be easy to test in isolation.
    def self.register_ability(ability)
      self.abilities.add(ability)
    end

    def self.remove_ability(ability)
      self.abilities.delete(ability)
    end

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
        can?(:read, topic.forum) && user.can_reply_to_forem_topic?(topic)
      end

      can :edit_post, Forem::Forum do |forum|
        user.can_edit_forem_posts?(forum)
      end
      
      can :destroy_post, Forem::Forum do |forum|
        user.can_destroy_forem_posts?(forum)
      end
      
      can :moderate, Forem::Forum do |forum|
        user.can_moderate_forem_forum?(forum) || user.forem_admin?
      end

      #include any abilities registered by extensions, etc.
      Ability.abilities.each do |clazz|
        ability = clazz.send(:new, user)
        @rules = rules + ability.send(:rules)
      end
    end
  end
end
