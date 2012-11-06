require 'friendly_id'

module Forem
  class Forum < ActiveRecord::Base
    include Forem::Concerns::Viewable

    extend FriendlyId
    friendly_id :title, :use => :slugged

    belongs_to :category

    has_many :topics,     :dependent => :destroy
    has_many :posts,      :through => :topics, :dependent => :destroy
    has_many :moderators, :through => :moderator_groups, :source => :group
    has_many :moderator_groups

    validates :category, :title, :description, :presence => true

    attr_accessible :category_id, :title, :description, :moderator_ids, :forem_protected, :logo, :icon
    
    has_attached_file :logo,
      :path           => '/:id/:style.:extension',
      :storage        => :s3,
      :url            => ':s3_alias_url',
      :s3_host_alias  => ENV["s3_host_alias"],
      :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
      :bucket         => ENV["s3_bucket"],
    :styles => {
      :thumb => ['50x50#', :png]
    }
    
    after_create :assign_mod_group

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
      user && (user.forem_group_ids & moderator_ids).any?
    end
    
    private
    
    def assign_mod_group
      g = Forem::Group.find_by_name category.name + Forem::Group::ADMIN_POSTFIX
      Forem::ModeratorGroup.create(group_id: g.id, forum_id: id)
    end
  end
end
