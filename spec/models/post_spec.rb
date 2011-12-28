require 'spec_helper'

describe Forem::Post do
  let(:post) { FactoryGirl.create(:post, :topic => stub_model(Forem::Topic)) }
  let(:reply) { FactoryGirl.create(:post, :reply_to => post) }

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
			@post = FactoryGirl.create( :post, :topic=>@topic )
			@topic.subscriptions.last.subscriber.should == @post.user
		end

		it "emails subscribers after post creation" do
			@post = FactoryGirl.build(:post)
			@post.should_receive(:email_topic_subscribers)
			@post.save
		end

		it "only emails other subscribers" do
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user)
			@topic = FactoryGirl.create( :topic )
			@post = FactoryGirl.create( :post, :topic=>@topic, :user=>@user2 )
			subs = [ Forem::Subscription.create(:topic=>@topic, :subscriber=>@user1), Forem::Subscription.create(:topic=>@topic, :subscriber=>@user2)]
			@post.topic.stub(:subscriptions).and_return(subs);
			@post.topic.stub_chain([:subscriptions, :includes]).and_return(subs);

			@post.topic.subscriptions.first.should_receive(:send_notification)
			@post.topic.subscriptions.last.should_not_receive(:send_notification)
			@post.email_topic_subscribers
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
