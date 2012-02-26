require 'spec_helper'

describe Forem::Post do
  let(:forum) { stub_model(Forem::Forum) }
  let(:topic) { stub_model(Forem::Topic, :forum => forum) }
  let(:post) { FactoryGirl.create(:post, :topic => topic) }
  let(:reply) { FactoryGirl.create(:post, :reply_to => post, :topic => topic) }

  context "upon deletion" do
    it "clears the reply_to_id for all replies" do
      reply.reply_to.should eql(post)
      post.destroy
      reply.reload
      reply.reply_to.should be_nil
    end
  end

  context "after creation" do
    it "subscribes the current poster" do
      @topic = FactoryGirl.create(:topic)
      @post = FactoryGirl.create(:post, :topic => @topic)
      @topic.subscriptions.last.subscriber.should == @post.user
    end

    it "emails subscribers after post creation" do
      @post = FactoryGirl.build(:post, :topic => topic)
      @post.should_receive(:email_topic_subscribers)
      @post.should_receive(:subscribe_replier)
      @post.save
    end

    it "only emails other subscribers" do
      @user2 = FactoryGirl.create(:user)
      @topic = FactoryGirl.create(:topic)

      @post = FactoryGirl.build(:post, :topic => @topic, :user => @user2)

      Forem::Subscription.any_instance.should_receive(:send_notification).once
      @post.save!
    end
  end

  context "helper methods" do
    it "retrieves the topic's forum" do
      post.forum.should == post.topic.forum
    end

    it "checks for post owner" do
      admin = FactoryGirl.create(:admin)
      assert post.owner_or_admin?(post.user)
      assert post.owner_or_admin?(admin)
    end

    it "subscribes repliers" do
      user = FactoryGirl.create(:user)
      post.user = user
      post.topic.should_receive(:subscribe_user).with(post.user_id)
      post.subscribe_replier
    end
  end
end
