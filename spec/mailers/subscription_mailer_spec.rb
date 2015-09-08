require 'spec_helper'

describe Forem::SubscriptionMailer do
  describe "topic_reply" do
    let(:user) { FactoryGirl.create(:user) }
    let(:topic) { FactoryGirl.create(:topic) }
    let(:post) { FactoryGirl.create(:post, :topic => topic) }
    let(:mail) { Forem::SubscriptionMailer.topic_reply(post.id, user.id) }

  it "sends an email announcing a forum post update" do
    expect(mail.to).to eq([user.email])
    expect(mail.subject).to eq(::I18n.t('received_reply', :scope => 'forem.topic'))
    expect(mail.body.encoded).to match(forum_topic_url(topic.forum, topic))
  end

    it "contains an unsubscribe link" do
      expect(mail.body.encoded).to match(unsubscribe_forum_topic_path(topic.forum, topic))
    end
  end
end
