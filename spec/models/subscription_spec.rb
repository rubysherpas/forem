require 'spec_helper'

describe Forem::Subscription do
  describe "topic subscriptions" do
    before(:each) do
      Forem::Topic.any_instance.stub(:set_first_post_user)
      Forem::Topic.any_instance.stub(:user).and_return(stub_model(User))
      attr = {
        :subject => "A topic",
      }
      @topic = Forem::Topic.create!(attr)
    end

    it "creates a subscription when a topic is created" do
      @topic.subscriptions.count.should == 1
    end

    it "adds the topic subscriber to the subscription" do
      @topic.subscriptions.first.subscriber.should == @topic.user
    end
  end
end
