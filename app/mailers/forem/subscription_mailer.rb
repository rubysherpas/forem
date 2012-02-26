module Forem
  class SubscriptionMailer < ActionMailer::Base
    default :from => Forem.email_from_address

    def topic_reply(post, subscriber)
      @post = post
      @subscriber = subscriber

      mail(:to => @subscriber.email, :subject => "A topic you are subscribed to has received a reply")
    end
  end
end
