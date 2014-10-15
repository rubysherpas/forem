require 'friendly_id'

module Forem
  class Category < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, :use => [:slugged, :finders]

    has_many :forums
    validates :name, :presence => true
    validates :position, numericality: { only_integer: true }

    def to_s
      name
    end

  end
end
