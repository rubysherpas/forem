require 'spec_helper'

describe 'topic permissions' do
  let!(:forum) { FactoryGirl.create(:forum) }
  let!(:topic) { FactoryGirl.create(:approved_topic, :forum => forum) }
  let!(:user) { FactoryGirl.create(:user) }

  context "without permission to create a new topic" do
    before do
      sign_in(user)
      User.any_instance.stub(:can_create_forem_topics?).and_return(false)
    end

    it "users can't see the link to create a topic" do
      visit forum_path(forum)
      assert_no_link_for!("New topic")
    end

    it "cannot visit the new action to create a new topic" do
      visit new_forum_topic_path(forum)
      access_denied!
    end
  end

  context "with, but then without permission to create a new topic" do
    before do
      sign_in(user)
    end

    it "cannot create a new topic" do
      # User has permission to do so when they navigate to the new page
      visit new_forum_topic_path(forum)
      fill_in "Subject", :with => "This is a subject"
      fill_in "Text", :with => "And this is some text"
      # And then doesn't
      User.any_instance.stub(:can_create_forem_topics?).and_return(false)
      click_button "Create Topic"
      access_denied!
    end
  end

  context "without permission to read a topic" do
    before do
      sign_in(user)
      User.any_instance.stub(:can_read_forem_topic?).and_return(false)
    end

    it "cannot subscribe to a topic" do
      visit subscribe_forum_topic_path(topic.forum, topic)
      access_denied!
    end
  end
end
