module Forem
  class Forum < ActiveRecord::Base
    has_many :topics, :dependent => :destroy
    has_many :posts, :through => :topics, :dependent => :destroy
    has_many :views, :through => :topics, :dependent => :destroy

    validates :title, :presence => true
    validates :description, :presence => true

    def last_post
      posts.last
    end

    def last_visible_post
      posts.where("forem_topics.hidden = ?", false).last
    end
  end
end
