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
  
  describe "validations" do
    it "requires a subject" do
      @topic.subject = nil
      @topic.should_not be_valid
    end
  end
  
  describe "protected attributes" do
    it "cannot assign pinned" do
      lambda { Forem::Topic.new(:pinned => true) }.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "cannot assign locked" do
      lambda { Forem::Topic.new(:locked => true) }.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "pinning" do
    before(:each) do
      Forem::Topic.delete_all
      @topic1 = FactoryGirl.create(:topic)
      @topic2 = FactoryGirl.create(:topic)
    end

    it "should show pinned topics up top" do
      Forem::Topic.by_pinned.first.should == @topic1
      @topic2.pin!
      Forem::Topic.by_pinned.first.should == @topic2
    end
  end

  describe ".by_most_recent_post" do
    before do
      Forem::Topic.delete_all
      Forem::Post.any_instance.stub(:email_topic_subscribers)
      @topic1 = Forem::Topic.create :subject => "POST"
      FactoryGirl.create(:post, :topic => @topic1, :created_at => 1.seconds.ago)
      @topic2 = Forem::Topic.create :subject => "POST"
      FactoryGirl.create(:post, :topic => @topic2, :created_at => 5.seconds.ago)
      @topic3 = Forem::Topic.create :subject => "POST"
      FactoryGirl.create(:post, :topic => @topic3, :created_at => 10.seconds.ago)
    end

    it "should show topics by most recent post" do
      Forem::Topic.by_most_recent_post.to_a.map(&:id).should == [@topic1.id, @topic2.id, @topic3.id]
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
