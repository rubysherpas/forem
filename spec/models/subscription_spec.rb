require 'spec_helper'

describe Forem::Subscription do

  it "is valid with valid attributes" do
    FactoryGirl.build(:subscription).should be_valid
  end

  describe "topic subscriptions" do
    before(:each) do
      Forem::Topic.any_instance.stub(:set_first_post_user)
      Forem::Topic.any_instance.stub(:user).and_return(stub_model(User))
      Forem::Topic.any_instance.stub(:user_id).and_return(1)
    end

    let(:attributes) do
      { :subject => "A topic" }
    end

    let(:topic) { Forem::Topic.new(attributes) }

    it "creates a subscription when a topic is created" do
      topic.stub(:subscriptions).and_return(subscriptions = stub)
      subscriptions.should_receive(:exists?).and_return(false)
      topic.subscriptions.should_receive(:create!).with(:subscriber_id => topic.user_id)
      topic.run_callbacks(:create)
    end

    # Regression test for #375
    it "does not send a notification when user is missing" do
      subscription = Forem::Subscription.new
      Forem::SubscriptionMailer.should_not_receive(:topic_reply)
      subscription.send_notification(1)
    end
  end
end
