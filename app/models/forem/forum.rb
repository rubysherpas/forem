class Forem::Forum < ActiveRecord::Base
  set_table_name :forem_forums
  has_many :topics
  has_many :posts, :through => :topics
  
  validates :title, :presence => true
  validates :description, :presence => true
end
