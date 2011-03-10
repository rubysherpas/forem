require 'spec_helper'

describe "topics" do
  # let(:forum) { Forem::Forum.create!(:title => "Welcome to forem!",
  #                                    :description => "FIRST FORUM") }
  # When FG is implemented
  let(:forum) { Factory(:forum) }
  let(:topic) { Factory(:topic) }

  context "not signed in" do
    before do
      sign_out!
    end
    it "cannot create a new topic" do
      visit new_forem_forum_topic_path(forum)
      flash_error!("You must sign in first.")
    end
  end

  context "signed in" do
    before do
      sign_in!
      visit new_forem_forum_topic_path(forum)
    end

    context "creating a topic" do

      it "is valid with subject and post text" do
        fill_in "Subject", :with => "FIRST TOPIC"
        fill_in "Text", :with => "omgomgomgomg"
        click_button 'Create Topic'

        flash_notice!("This topic has been created.")
        assert_seen("FIRST TOPIC", :within => :topic_header)
        assert_seen("omgomgomgomg", :within => :post_text)
        assert_seen("forem_user", :within => :post_user)

      end

      it "is invalid without subject but with post text" do
        click_button 'Create Topic'

        flash_error!("This topic could not be created.")
        find_field("topic_subject").value.should eql("")
        find_field("topic_posts_attributes_0_text").value.should eql("")
      end
    end
  end

  context "viewing a topic" do
    # Todo: Factory'ize
    let(:topic) do
      attributes = { :subject => "FIRST TOPIC",
        :posts_attributes => {
          "0" => {
            :text => "omgomgomg",
            :user => User.first
          }
        }
      }

      forum.topics.create(attributes)
    end

    it "is free for all" do
      visit forem_forum_topic_path(forum, topic)
      assert_seen("FIRST TOPIC", :within => :topic_header)
      assert_seen("omgomgomg", :within => :post_text)
    end
  end
end