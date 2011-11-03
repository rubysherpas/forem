module Forem
  class Category < ActiveRecord::Base
    has_many :forums
    validates :name, :presence => true

  end
end