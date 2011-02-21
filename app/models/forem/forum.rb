class Forem::Forum < ActiveRecord::Base
  has_many :topics, :class_name => "Forem::Topic"
  has_many :posts, :through => :topics

end
