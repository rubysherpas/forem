require 'spec_helper'

describe "topic listing" do
  context "shows correct last post for a topic" do
    let!(:user) { create(:user) }
    let!(:forum) { create(:forum) }
    let!(:topic) { create(:approved_topic, :forum => forum, :user => user) }

    let!(:approved_post) do
      topic.posts.first.tap do |post|
        post.update_attribute(:state, "approved")
      end
    end

    let!(:unapproved_post) do
      create(:post, :topic => topic, :user => user, :created_at => 2.days.from_now).tap do |post|
        post.update_attribute(:state, "pending_review")
      end
    end

    def last_post_anchor
      page.find(".latest-post a")["href"].split("#").last
    end

    context "for regular users" do
      it "shows approved post as latest post" do
        visit forum_path(forum)
        expect(last_post_anchor).to eq("post-#{approved_post.id}")
      end

      it "shows topics by deleted users" do
        approved_post.update_column(:user_id, nil)
        visit forum_path(forum)
        expect(page).to have_content("Started by [deleted]")
      end
    end

    context "for admins" do
      before do
        user.update_attribute(:forem_admin, true)
        sign_in(user)
      end

      it "sees unapproved post as last post" do
        visit forum_path(forum)
        expect(last_post_anchor).to eq("post-#{unapproved_post.id}")
      end
    end

    context "for moderators" do
      before do
        allow_any_instance_of(Forem::Forum).to receive_messages :moderator? => true
        sign_in(user)
      end

      it "sees unapproved post as last post" do
        visit forum_path(forum)
        expect(last_post_anchor).to eq("post-#{unapproved_post.id}")
      end
    end
  end
end
