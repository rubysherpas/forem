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
    
    validate :is_recursive_category?, if: :category
    validate :has_one_level?, if: :category

    def to_s
      name
    end
    
    def create_groups
      Forem::Group.create(name: name)
      Forem::Group.create(name: name + Forem::Group::ADMIN_POSTFIX)
    end
    
    private
    
    def is_recursive_category?
      errors.add(:category_id, 'Category cannot be its own child/parent.') if id == category_id
    end
    
    def has_one_level?
      errors.add(:category_id, 'Only one level of categories allowed.') unless category.category.nil?
    end

  end
end
