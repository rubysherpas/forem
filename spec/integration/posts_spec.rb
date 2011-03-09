require 'spec_helper'

describe "posts" do
  # TODO: FG'ize
  let(:forum) { Factory(:forum) }
  let(:topic) { Factory(:topic, :forum => forum) }
  
  context "not signed in users " do
    it "cannot begin to post a reply" do
      visit new_topic_post_path(topic)
      flash_error!("You must sign in first.")
    end
  end

  context "signed in users" do
    before do
      sign_in!
      visit forum_topic_path(forum, topic)
      within(selector_for(:first_post)) do
        click_link("Reply")
      end
    end

    it "can post a reply to a topic" do
      fill_in "Text", :with => "Witty and insightful commentary."
      click_button "Post Reply"
      flash_notice!("Your reply has been posted.")
      assert_seen("In reply to #{topic.posts.first.user}", :within => :second_post)
    end
    
    it "cannot post a reply to a topic with blank text" do
      click_button "Post Reply"
      flash_error!("Your reply could not be posted.")
    end
    
    it "can delete own post" do
      click_button "Delete Post"
      flash_notice!("Your post has been deleted.")
      / assert that post is gone?/
    end
  end
end