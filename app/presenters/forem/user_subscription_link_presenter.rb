module Forem
  class UserSubscriptionLinkPresenter

    def initialize(context, user, topic)
      self.context = context
      self.user = user
      self.topic = topic
    end

    def to_s
      if !topic.subscriber?(user.id)
        subscribe_link
      else
        unsubscribe_link
      end
    end

    protected
    attr_accessor :context, :user, :topic
    delegate :forem, :link_to, :t, :to => :context

    def subscribe_link
      link_to t('subscribe', :scope => 'forem.topics.show'),
              forem.subscribe_forum_topic_path(topic.forum, topic)
    end

    def unsubscribe_link
      link_to t('unsubscribe', :scope => 'forem.topics.show'),
              forem.unsubscribe_forum_topic_path(topic.forum, topic)
    end

  end
end
