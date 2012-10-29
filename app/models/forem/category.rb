require 'friendly_id'

module Forem
  class Category < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, :use => :slugged

    has_many :forums
    validates :name, :presence => true
    attr_accessible :name, :forem_public
    
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
