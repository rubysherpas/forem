require 'spec_helper'

describe "topics" do
  before do
    @forum = Forem::Forum.create!(:title => "Welcome to Forem!",
                                 :description => "A placeholder forum.")
  end

  context "not signed in" do
    it "cannot create a new topic" do
      visit new_forum_topic_path(@forum)
      flash_error!("You must sign in first.")
    end
  end

  context "signed in" do
    before do
      sign_in!(:login => "Magic Johnson")
      visit new_forum_topic_path(@forum)
    end

    context "creating a topic" do

      it "is valid with subject and post text" do
        fill_in "Subject", :with => "FIRST TOPIC"
        fill_in "Text", :with => "omgomgomgomg"
        click_button 'Create Topic'

        flash_notice!("This topic has been created.")
        assert_seen("FIRST TOPIC", :within => "#topic h2")
        assert_seen("omgomgomgomg", :within => "#posts .post .text")
        assert_seen("forem_user", :within => "#posts .post .user")

      end

      it "is invalid without subject but with post text" do
        click_button 'Create Topic'

        flash_error!("This topic could not be created.")
        find_field("topic_subject").value.should eql("")
        find_field("topic_posts_attributes_0_text").value.should eql("")
      end
    end
  end
end