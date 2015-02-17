require 'spec_helper'

describe "moderation" do
  let(:forum) { FactoryGirl.create(:forum) }

  context "approved users" do
    let(:user) { FactoryGirl.create(:user, :forem_state => 'approved') }
    before { sign_in(user) }

    it "subsequent topics bypass the moderation queue" do
      visit new_forum_topic_path(forum)
      fill_in "Subject", :with => "SECOND TOPIC"
      fill_in "Text", :with => "User's second words"
      click_button "Create Topic"
      flash_notice!("This topic has been created.")
      expect(page).not_to have_content("This topic is currently pending review.")
    end

    it "subsequent posts bypass the moderation queue" do
      topic = FactoryGirl.create(:approved_topic, :forum => forum)
      visit forum_topic_path(forum, topic)

      within(".post") do
        click_link "Reply"
      end

      fill_in "Text", :with => "Freedom!!"
      click_button "Reply"
      flash_notice!("Your reply has been posted.")
      expect(page).not_to have_content("This post is currently pending review.")
    end
  end
end
