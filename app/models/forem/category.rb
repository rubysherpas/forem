require 'friendly_id'

module Forem
  class Category < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, :use => :slugged

    has_many :categories
    has_many :forums
    belongs_to :category
    validates :name, :presence => true
    attr_accessible :name, :forem_public, :category_id
    
    after_save :create_groups

    def to_s
      name
    end
    
    def create_groups
      Forem::Group.create(name: name)
      Forem::Group.create(name: name + Forem::Group::ADMIN_POSTFIX)
    end

  end
end
