require 'friendly_id'

module Forem
  class Forum < ActiveRecord::Base
    include Forem::Concerns::Viewable

    extend FriendlyId
    friendly_id :name, :use => :slugged

    belongs_to :category

    has_many :topics,     :dependent => :destroy
    has_many :posts,      :through => :topics, :dependent => :destroy
    has_many :moderators, :through => :moderator_groups, :source => :group
    has_many :moderator_groups

    validates :category, :name, :description, :presence => true

    attr_accessible :category_id, :title, :name, :description, :moderator_ids

    alias_attribute :title, :name

    # Fix for #339
    default_scope order('name ASC')

    def last_post_for(forem_user)
      if forem_user && (forem_user.forem_admin? || moderator?(forem_user))
        posts.last
      else
        last_visible_post(forem_user)
      end
    end

    def last_visible_post(forem_user)
      posts.approved_or_pending_review_for(forem_user).last
    end

    def moderator?(user)
      user && belongs_to_moderator_group(user)
    end

    def to_s
      name
    end

    private

    # could be much cleaner using moderator_ids and user.forem_group_ids
    # but unfortunately it breaks jruby builds
    def belongs_to_moderator_group(user)
      (forem_group_ids_for(user) & get_moderator_ids).any?
    end

    def forem_group_ids_for(user)
      user.forem_groups.map { |u| u.id }
    end

    def get_moderator_ids
      moderators.map { |m| m.id }
    end
  end
end
