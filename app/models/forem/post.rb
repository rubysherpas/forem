module Forem
  class Post < ActiveRecord::Base
    belongs_to :topic
    belongs_to :user, :class_name => Forem.user_class.to_s
    belongs_to :reply_to, :class_name => "Post"

    has_many :replies, :class_name => "Post",
                       :foreign_key => "reply_to_id",
                       :dependent => :nullify

    delegate :forum, :to => :topic

    scope :visible, joins(:topic).where("forem_topics.hidden" => false)
    scope :by_created_at, order("created_at asc")

    validates :text, :presence => true
  	after_create :subscribe_replier
  	after_create :email_topic_subscribers

    def owner_or_admin?(other_user)
      self.user == other_user || other_user.forem_admin?
    end

    def subscribe_replier
      if self.topic && self.user
        self.topic.subscribe_user(self.user.id)
      end
    end

  	def email_topic_subscribers
  		if self.topic
  			self.topic.subscriptions.includes(:subscriber).each do |subscription|
  				if subscription.subscriber != self.user
  					subscription.send_notification(self.id)
  				end
  			end
  		end
  	end
  end
end
