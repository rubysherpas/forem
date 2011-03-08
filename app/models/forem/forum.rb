class Forem::Forum < ActiveRecord::Base
  has_many :topics, :dependent => :destroy
  has_many :posts, :through => :topics, :dependent => :destroy
  
  validates :title, :presence => true
  validates :description, :presence => true
end
