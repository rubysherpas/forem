require 'spec_helper'

describe "moderation" do
  let(:forum) { FactoryGirl.create(:forum) }
  let(:user) { FactoryGirl.create(:user) }

  context "as a new user" do
    before do
      sign_in(user)
    end

    it "has their first topic moderated" do
      visit new_forum_topic_path(forum)
      fill_in "Subject", :with => "FIRST TOPIC"
      fill_in "Text", :with => "User's first words"
      click_button "Create Topic"

      flash_notice!("This topic has been created.")
      assert_seen("This topic is currently pending review. Only the user who created it and moderators can view it.", :within => :topic_moderation)
    end


    it "has their first post moderated" do
      topic = Factory(:topic, :forum => forum)
      topic.approve!
      visit forum_topic_path(forum, topic)

      click_link "Reply"
      fill_in "Text", :with => "I am replying to a topic."
      click_button "Reply"

      flash_notice!("Your reply has been posted.")
      assert_seen("This post is currently pending review. Only the user who posted it and moderators can view it.", :within => :post_moderation)
    end

    it "cannot see the moderation tools" do
      visit forum_path(forum)
      page.should_not have_content("Moderation Tools")
    end

    it "cannot see a unapproved topic by another user" do
      topic = Factory(:topic, :forum => forum, :subject => "In review")
      visit forum_path(forum)
      page.should_not have_content("In review")

      visit forum_topic_path(forum, topic)
      flash_alert!("The topic you are looking for could not be found.")
    end

    it "cannot see an unapproved posts by another user" do
      topic = Factory(:topic, :forum => forum)
      post = Factory(:post, :topic => topic, :text => "BUY VIAGRA")
      topic.approve!

      visit forum_topic_path(forum, topic)
      page.should_not have_content("BUY VIAGRA")
    end
  end
end
