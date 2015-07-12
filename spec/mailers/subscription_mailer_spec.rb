require 'spec_helper'

describe Forem::SubscriptionMailer do
  describe "topic_reply" do
    let(:user) { FactoryGirl.create(:user) }
    let(:topic) { FactoryGirl.create(:topic) }
    let(:post) { FactoryGirl.create(:post, :topic => topic) }
    let(:mail) { Forem::SubscriptionMailer.topic_reply(post.id, user.id) }

  it "sends an email announcing a forum post update" do
    mail.to.should eq([user.email])
    mail.subject.should eq(::I18n.t('received_reply', :scope => 'forem.topic'))
    mail.body.encoded.should match(forum_topic_url(topic.forum, topic))
  end

    it "contains an unsubscribe link" do
      mail.body.encoded.should match(unsubscribe_forum_topic_path(topic.forum, topic))
    end
  end
end
