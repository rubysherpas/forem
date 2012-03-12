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
      topic = Forem::Topic.new(:pinned => true)
      topic.pinned.should be_false
    end
    
    it "cannot assign locked" do
      topic = Forem::Topic.new(:locked => true)
      topic.locked.should be_false
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

    describe "#register_view_by" do
      before do
        @user = FactoryGirl.create(:user)
      end

      it "increments the overall topic view count" do
        count = @topic.views_count
        @topic.register_view_by(@user)
        @topic.views_count.should eq(count+1)
      end

      it "increments the users view count for the topic" do
        @topic.views.create(:user => @user, :count => 1)
        @topic.register_view_by(@user)

        @topic.view_for(@user).count.should eq(2)
      end

      it "doesn't update the view time if less than 15 minutes ago" do
        cur_time = Time.now.utc
        @topic.views.create(:user => @user, :current_viewed_at => cur_time)
        @topic.register_view_by(@user)

        @topic.view_for(@user).current_viewed_at.to_i.should eq(cur_time.to_i)
      end

      it "does update the view time if more than 15 minutes ago" do
        t = Time.parse("03/01/2012 10:00")
        Time.stub(:now).and_return(t)

        last_hour = 1.hour.ago.utc
        @topic.views.create(:user => @user, :current_viewed_at => last_hour)
        @topic.register_view_by(@user)

        @topic.view_for(@user).current_viewed_at.to_i.should eq(t.to_i)
      end
    end
  end
end
