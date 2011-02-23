class Forem::Forum < ActiveRecord::Base
  has_many :topics
  has_many :posts, :through => :topics
end
