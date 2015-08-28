require 'spec_helper'
require 'timecop'

describe Forem::Topic do
  let(:topic) do
    FactoryGirl.create(:topic)
  end

  it "is valid with valid attributes" do
    expect(topic).to be_valid
  end

  context "creation" do
    it "is automatically pending review" do
      expect(topic).to be_pending_review
    end
  end

  context "deletion" do
    it "deletes posts" do
      FactoryGirl.create(:post, :topic => topic)
      topic.reload
      topic.destroy
      expect(Forem::Post.exists?(:topic_id => topic.id)).to be false
    end

    it "deletes views" do
      FactoryGirl.create(:topic_view, :viewable => topic)
      topic.destroy
      expect(Forem::View.exists?(:viewable_id => topic.id)).to be false
    end

    it "deletes subscriptions" do
      FactoryGirl.create(:subscription, :topic => topic)
      topic.destroy
      expect(Forem::Subscription.exists?(:topic_id => topic.id)).to be false
    end
  end  

  describe "validations" do
    it "requires a subject" do
      topic.subject = nil
      expect(topic).not_to be_valid
    end

    it "requires a subject not too long" do
      topic.subject = 'x' * 256
      expect(topic).not_to be_valid
    end
  end

  describe "pinning" do
    it "should show pinned topics up top" do
      ordering = Forem::Topic.by_pinned.order_values
      expect(ordering).to include("forem_topics.pinned DESC")
    end
  end

  describe "approving" do
    let(:unapproved_topic) { FactoryGirl.create(:topic, :user => FactoryGirl.create(:user)) }

    it "switches pending review status" do
      allow_any_instance_of(Forem::Post).to receive(:subscribe_replier)
      unapproved_topic.approve!
      expect(unapproved_topic.posts.by_created_at.first).not_to be_pending_review
    end
  end

  describe ".by_most_recent_post" do
    it "should show topics by most recent post" do
      ordering = Forem::Topic.by_most_recent_post.order_values
      expect(ordering).to include("forem_topics.last_post_at DESC")
    end
  end

  describe ".by_pinned_or_most_recent_post" do
    it "should show topics by pinned then by most recent post" do
      ordering = Forem::Topic.by_pinned_or_most_recent_post.order_values
      expect(ordering).to eq(["forem_topics.pinned DESC", "forem_topics.last_post_at DESC", "forem_topics.id"]) 
    end
  end

  describe ".set_first_post_user" do
    it "should handle deleted user" do
      topic.user_id = nil
      topic.save
    end
  end

  describe "helper methods" do
    describe "#subscribe_user" do
      let(:subscription_user) { FactoryGirl.create(:user) }
      it "subscribes a user to the topic" do
        topic.subscribe_user(subscription_user.id)
        expect(topic.subscriptions.last.subscriber).to eq(subscription_user)
      end

      it "only subscribes users once" do
        expect {
          2.times { topic.subscribe_user(subscription_user.id) }
        }.to change(topic.subscriptions, :count).by(1)
      end
    end

    describe "#register_view_by" do
      let!(:view_user) { FactoryGirl.create(:user) }

      it "increments the overall topic view count" do
        expect {
          topic.register_view_by(view_user)
        }.to change(topic, :views_count).by(1)
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

        expect(topic.view_for(view_user).current_viewed_at.to_i).to eq(frozen_time.to_i)
      end

      it "does update the view time if more than 15 minutes ago" do
        frozen_time = Time.parse("03/01/2012 10:00")
        Timecop.freeze(frozen_time) do
          last_hour = 1.hour.ago.utc
          topic.views.create(:user => view_user, :current_viewed_at => last_hour)
        end

        Timecop.freeze(Time.now) do
          topic.register_view_by(view_user)
          expect(topic.view_for(view_user).current_viewed_at.to_i).to eq(Time.now.to_i)
        end
      end
    end
  end
end
