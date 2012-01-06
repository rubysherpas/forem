require 'spec_helper'

describe Forem::SubscriptionMailer do
  describe "topic_reply" do
    let(:user) { Factory(:user) }
    let(:topic) { Factory(:topic) }
    let(:post) { Factory(:post, :topic=>topic) }
    let(:mail) { Forem::SubscriptionMailer.topic_reply(post.id, user.id) }

		it "sends an email announcing a forum post update" do
			mail.to.should eq([user.email])
			mail.subject.should eq("A topic you are subscribed to has received a reply")
      mail.body.encoded.should match(forum_topic_url(topic.forum, topic))
		end

    it "contains an unsubscribe link" do
      mail.body.encoded.should match(unsubscribe_topic_path(topic))
    end
	end
end
