require 'spec_helper'
require 'timecop'

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
    [:pinned, :locked].each do |attr|
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
    let(:topic) { FactoryGirl.create(:topic, :user => stub_model(User)) }

    it "switches pending review status" do
      Forem::Post.any_instance.stub(:subscribe_replier)
      topic.approve!
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
        frozen_time = 1.minute.ago
        Timecop.freeze(frozen_time) do
          @topic.views.create :user => @user
        end

        @topic.register_view_by(@user)

        @topic.view_for(@user).current_viewed_at.to_i.should eq(frozen_time.to_i)
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
