require 'spec_helper'

describe Forem::Topic do
  before(:each) do
    Forem::Topic.any_instance.stub(:set_first_post_user).and_return(true)
    @attr = {
      :subject => "A topic"
    }
    @topic = Forem::Topic.create!(@attr)
  end
  
  it "is valid with valid attributes" do
    @topic.should be_valid
  end

  context "creation" do
    it "is automatically pending review" do
      @topic.should be_pending_review
    end
  end
  
  describe "validations" do
    it "requires a subject" do
      @topic.subject = nil
      @topic.should_not be_valid
    end
  end
  
  describe "protected attributes" do
    protected_attributes = [:pinned, :locked, :pending_review]
    protected_attributes.each do |attr|
      it "cannot assign #{attr}" do
        lambda { Forem::Topic.new(attr => true) }.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end

  describe "pinning" do
    it "should show pinned topics up top" do
      ordering = Forem::Topic.by_pinned.order_values
      ordering.should include("forem_topics.pinned DESC")
    end
  end

  describe "approving" do
    let(:topic) { Factory(:topic, :user => stub_model(User)) }

    it "switches pending review status" do
      Forem::Post.any_instance.stub(:subscribe_replier)
      topic.approve!
      topic.pending_review.should be_false
      topic.posts.by_created_at.first.should_not be_pending_review
    end
  end

  describe ".by_most_recent_post" do
    it "should show topics by most recent post" do
      ordering = Forem::Topic.by_most_recent_post.order_values
      ordering.should include("forem_topics.last_post_at DESC")
    end
  end

  describe "helper methods" do
    describe "#subscribe_user" do
      it "subscribes a user to the topic" do
        user = FactoryGirl.create(:user)
        @topic.subscribe_user(user.id)
        @topic.subscriptions.last.subscriber.should == user
      end

      it "only subscribes users once" do
        user = FactoryGirl.create(:user)
        @topic.subscribe_user(user.id)
        @topic.subscribe_user(user.id)
        @topic.subscriptions.size.should == 1
      end
    end
  end
end
