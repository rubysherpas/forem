require 'spec_helper'

describe "topic listing" do
  context "shows correct last post for a topic" do
    let!(:user) { create(:user) }
    let!(:forum) { create(:forum) }
    let!(:topic) { create(:approved_topic, :forum => forum, :user => user) }
    let!(:approved_post) { create(:approved_post, :topic => topic, :user => user, :created_at => 1.day.from_now) }
    let!(:unapproved_post) { create(:post, :topic => topic, :user => user, :created_at => 2.days.from_now) }

    before do
      unapproved_post.update_attribute(:state, "pending_review")
    end

    def last_post_anchor
      page.find(".latest-post a")["href"].split("#").last
    end

    context "for regular users" do
      it "shows approved post as latest post" do
        visit forum_path(forum)
        last_post_anchor.should == "post-#{approved_post.id}"
      end
    end

    context "for admins" do
      before do
        user.update_attribute(:forem_admin, true)
        sign_in(user)
      end

      it "sees unapproved post as last post" do
        visit forum_path(forum)
        last_post_anchor.should == "post-#{unapproved_post.id}"
      end
    end

    context "for moderators" do
      before do
        Forem::Forum.any_instance.stub :moderator? => true
        sign_in(user)
      end

      it "sees unapproved post as last post" do
        visit forum_path(forum)
        last_post_anchor.should == "post-#{unapproved_post.id}"
      end
    end
  end
end
