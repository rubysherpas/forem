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
