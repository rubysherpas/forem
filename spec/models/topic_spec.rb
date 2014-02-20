require 'spec_helper'
require 'timecop'

describe Forem::Topic do
  let(:topic) do
    FactoryGirl.create(:topic)
  end

  it "is valid with valid attributes" do
    topic.should be_valid
  end

  context "creation" do
    it "is automatically pending review" do
      topic.should be_pending_review
    end
  end

  describe "validations" do
    it "requires a subject" do
      topic.subject = nil
      topic.should_not be_valid
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
    let(:unapproved_topic) { FactoryGirl.create(:topic, :user => FactoryGirl.create(:user)) }

    it "switches pending review status" do
      Forem::Post.any_instance.stub(:subscribe_replier)
      unapproved_topic.approve!
      unapproved_topic.posts.by_created_at.first.should_not be_pending_review
    end
  end

  describe ".by_most_recent_post" do
    it "should show topics by most recent post" do
      ordering = Forem::Topic.by_most_recent_post.order_values
      ordering.should include("forem_topics.last_post_at DESC")
    end
  end

  describe ".by_pinned_or_most_recent_post" do
    it "should show topics by pinned then by most recent post" do
      ordering = Forem::Topic.by_pinned_or_most_recent_post.order_values
      ordering.should == ["forem_topics.pinned DESC", "forem_topics.last_post_at DESC", "forem_topics.id"] 
    end
  end

  describe "helper methods" do
    describe "#subscribe_user" do
      let(:subscription_user) { FactoryGirl.create(:user) }
      it "subscribes a user to the topic" do
        topic.subscribe_user(subscription_user.id)
        topic.subscriptions.last.subscriber.should == subscription_user
      end

      it "only subscribes users once" do
        expect {
          2.times { topic.subscribe_user(subscription_user.id) }
        }.to change { topic.subscriptions.count}.from(topic.subscriptions.count).by(1)
      end
    end

    describe "#register_view_by" do
      let!(:view_user) { FactoryGirl.create(:user) }

      it "increments the overall topic view count" do
        expect {
          topic.register_view_by(view_user)
        }.to change { topic.views_count }.from(topic.views_count).by(1)
      end

      it "increments the users view count for the topic" do
        topic.views.create(:user => view_user, :count => 1)
        expect {
          topic.register_view_by(view_user)
        }.to change { topic.view_for(view_user).count }.from(1).to(2)
      end

      it "doesn't update the view time if less than 15 minutes ago" do
        frozen_time = 1.minute.ago
        Timecop.freeze(frozen_time) do
          topic.views.create :user => view_user
        end

        topic.register_view_by(view_user)

        topic.view_for(view_user).current_viewed_at.to_i.should eq(frozen_time.to_i)
      end

      it "does update the view time if more than 15 minutes ago" do
        frozen_time = Time.parse("03/01/2012 10:00")
        Timecop.freeze(frozen_time) do
          last_hour = 1.hour.ago.utc
          topic.views.create(:user => view_user, :current_viewed_at => last_hour)
        end

        Timecop.freeze(Time.now) do
          topic.register_view_by(view_user)
          topic.view_for(view_user).current_viewed_at.to_i.should eq(Time.now.to_i)
        end
      end
    end
  end
end
