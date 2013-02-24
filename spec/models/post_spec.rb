require 'spec_helper'
require 'timecop'

describe Forem::Post do
  let!(:forum) { stub_model(Forem::Forum) }
  let!(:topic) { stub_model(Forem::Topic, :forum => forum) }
  let!(:post) { FactoryGirl.create(:post, :topic => topic) }
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
    it "subscribes the current poster if forem_auto_subscribe is set to true" do
      topic.subscriptions.last.subscriber.should == post.user
    end

    it "doesn't subscribe the current poster if forem_auto_subscribe is set to false" do
      user_not_autosubscribed = FactoryGirl.create(:not_autosubscribed)
      post = FactoryGirl.build(:approved_post, :topic => topic, :user => user_not_autosubscribed)

      topic.subscriptions.last.subscriber.should_not == post.user
    end

    it "does not email subscribers after post creation if not approved" do
      post.should_not be_approved
      post.should_not_receive(:email_topic_subscribers)
      post.save
    end

    it "only emails subscribers when post is approved" do
      post.should_receive(:email_topic_subscribers)
      post.approve!
    end

    it "does not send out notifications if notifications have already been sent" do
      post.should_not_receive(:email_topic_subscribers)
      post.save
    end

    it "only emails other subscribers" do
      user_2 = FactoryGirl.create(:user)
      Forem::Subscription.any_instance.should_receive(:send_notification).once
      post = FactoryGirl.build(:approved_post, :topic => topic, :user => user_2)
      post.save!
    end

    it "sets topics last_post_at value" do
      new_topic = FactoryGirl.create(:topic)
      new_post = new_topic.posts.last
      new_topic.reload
      new_topic.last_post_at.to_s.should == new_post.created_at.to_s
      # Regression test for #255. Issue introduced by 46345c4
      Timecop.freeze(Time.now + 1.minute) do
        new_post_2 = FactoryGirl.create(:post, :topic => new_topic)
        new_topic.reload
        new_topic.last_post_at.to_s.should == new_post_2.created_at.to_s
      end
    end
  end

  context "Forum counters" do
    describe "#update_forum_posts_count" do
      it "increments #posts_count on create" do
        forum = FactoryGirl.create(:forum)
        count = forum.posts_count
        new_topic = FactoryGirl.create(:topic, forum: forum)
        forum.reload.posts.count.should == count + 1
        forum.reload.posts_count.should == count + 1
      end

      it "does not increment #posts_count on save" do
        forum = FactoryGirl.create(:forum)
        count = forum.posts_count
        new_topic = FactoryGirl.create(:topic, forum: forum)
        new_count = count + 1
        forum.reload.posts.count.should == new_count
        forum.reload.posts_count.should == new_count
        new_topic.save!
        forum.reload.posts_count.should == new_count
      end
    end


    describe "#update_forum_posts_approved_count" do
      let!(:forum) { FactoryGirl.create(:forum) }
      let!(:topic) { FactoryGirl.create(:topic, :forum => forum) }
      let!(:approved_count) { forum.posts.approved.count }

      before do
        post.topic = topic
        post.save!
      end

      it "does nothing if the state doesn't change" do
        post.save!
        forum.reload.posts.approved.count.should == approved_count
        forum.reload.posts_approved_count.should == approved_count
      end

      it "does not increment the topics_approved_count for spam" do
        post.spam!
        forum.reload.posts.approved.count.should == approved_count
        forum.reload.posts_approved_count.should == approved_count
      end

      it "increments the topics_approved_count when the state is approved" do
        post.approve!
        forum.reload.posts.approved.count.should == approved_count + 1
        forum.reload.posts_approved_count.should == approved_count + 1
      end
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
  end
end
