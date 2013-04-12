require 'spec_helper'

describe "moderation" do
  let(:forum) { FactoryGirl.create(:forum) }
  let(:user) { FactoryGirl.create(:user) }

  context "approved users" do
    before do
      sign_in(user)
      User.any_instance.stub(:forem_state).and_return("approved")
    end

    it "subsequent topics bypass the moderation queue" do
      visit new_forum_topic_path(forum)
      fill_in "Subject", :with => "SECOND TOPIC"
      fill_in "Text", :with => "User's second words"
      click_button "Create Topic"
      flash_notice!("This topic has been created.")
      page.should_not have_content("This topic is currently pending review.")
    end

    it "subsequent posts bypass the moderation queue" do
      topic = FactoryGirl.create(:approved_topic, :forum => forum)
      visit forum_topic_path(forum, topic)

      within("menu") do
        click_link "Reply"
      end

      fill_in "Text", :with => "Freedom!!"
      click_button "Reply"
      flash_notice!("Your reply has been posted.")
      page.should_not have_content("This post is currently pending review.")
    end
  end
end
