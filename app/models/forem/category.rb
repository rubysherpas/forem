require 'friendly_id'

module Forem
  class Category < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, :use => [:slugged, :finders]

    has_many :forums
    validates :name, :presence => true

    def self.scoped_to(account)
      where(:account_id => account.id)
    end

    def to_s
      name
    end

  end
end
