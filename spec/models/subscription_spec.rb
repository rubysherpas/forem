require 'spec_helper'

describe Forem::Subscription do
  let(:subscription) do
    FactoryGirl.create(:subscription)
  end

  it "is valid with valid attributes" do
    expect(subscription).to be_valid
  end

  describe "topic subscriptions" do
    before(:each) do
      allow_any_instance_of(Forem::Topic).to receive(:set_first_post_user)
      allow_any_instance_of(Forem::Topic).to receive(:user).and_return(stub_model(User))
      allow_any_instance_of(Forem::Topic).to receive(:user_id).and_return(1)
    end

    let(:attributes) do
      { :subject => "A topic" }
    end

    let(:topic) { Forem::Topic.new(attributes) }

    it "creates a subscription when a topic is created" do
      expect { topic.save }.to change { topic.subscriptions.count }.from(0).to(1)
    end

    # Regression test for #375
    it "does not send a notification when user is missing" do
      subscription = Forem::Subscription.new
      expect(Forem::SubscriptionMailer).not_to receive(:topic_reply)
      subscription.send_notification(1)
    end
  end
end
