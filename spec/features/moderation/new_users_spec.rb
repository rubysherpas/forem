require 'spec_helper'

describe "moderation" do
  let(:forum) { FactoryGirl.create(:forum) }
  let(:user) { FactoryGirl.create(:user) }

  context "with moderation enabled" do
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
        assert_seen("This topic is currently pending review. Only the user who created it and moderators can view it.")
      end


      it "has their first post moderated" do
        topic = FactoryGirl.create(:topic, :forum => forum)
        topic.approve!
        visit forum_topic_path(forum, topic)

        within("menu") do
          click_link "Reply"
        end

        fill_in "Text", :with => "I am replying to a topic."
        click_button "Reply"

        flash_notice!("Your reply has been posted.")
        assert_seen("This post is currently pending review. Only the user who posted it and moderators can view it.", :within => :post_moderation)
      end

      it "cannot see the moderation tools" do
        visit forum_path(forum)
        # page.should_not have_content("Moderation Tools")
        page.html.should_not match("Moderation Tools")
      end

      it "cannot see a unapproved topic by another user" do
        topic = FactoryGirl.create(:topic, :forum => forum, :subject => "In review")
        visit forum_path(forum)
        page.should_not have_content("In review")

        visit forum_topic_path(forum, topic)
        flash_alert!("The topic you are looking for could not be found.")
      end

      it "cannot see an unapproved posts by another user" do
        topic = FactoryGirl.create(:topic, :forum => forum)
        post = FactoryGirl.create(:post, :topic => topic, :text => "BUY VIAGRA")
        topic.approve!

        visit forum_topic_path(forum, topic)
        # page.should_not have_content("BUY VIAGRA")
        page.html.should_not match("BUY VIAGRA")
      end
    end
  end

  context "with moderation disabled" do
    before do
      Forem.moderate_first_post = false
    end

    after do
      Forem.moderate_first_post = true
    end

    context "as a new user" do
      before do
        sign_in(user)
      end

      it "does not have their first topic moderated" do
        visit new_forum_topic_path(forum)
        fill_in "Subject", :with => "FIRST TOPIC"
        fill_in "Text", :with => "User's first words"
        click_button "Create Topic"

        flash_notice!("This topic has been created.")
        page.should_not have_content("This topic is currently pending review.")
      end


      it "does not have their first post moderated" do
        topic = FactoryGirl.create(:topic, :forum => forum)
        visit forum_topic_path(forum, topic)

        within("menu") do
          click_link "Reply"
        end

        fill_in "Text", :with => "I am replying to a topic."
        click_button "Reply"

        flash_notice!("Your reply has been posted.")
        page.should_not have_content("This post is currently pending review.")
      end
    end
  end
end
