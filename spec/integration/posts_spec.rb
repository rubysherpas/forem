require 'spec_helper'

describe "posts" do
  before do
    User.delete_all
    ::Forem::Forum.delete_all
    ::Forem::Topic.delete_all
    ::Forem::View.delete_all
  end

  let(:forum) { FactoryGirl.create(:forum) }
  let(:topic) { FactoryGirl.create(:topic, :forum => forum) }
  
  context "not signed in users" do
    it "cannot begin to post a reply" do
      visit new_topic_post_path(topic)
      flash_alert!("You must sign in first.")
    end
    
    it "cannot delete posts" do
      first_post = topic.posts[0]
      delete topic_post_path(topic, first_post), :id => first_post.id.to_s
      response.should redirect_to(sign_in_path)
      flash.alert.should == "You must sign in first."
    end
  end

  context "signed in users" do
    context "replying" do
      before do
        sign_in!
        visit forum_topic_path(forum, topic)
        within(selector_for(:first_post)) do
          click_link("Reply")
        end
      end

      context "to an unlocked topic" do
        it "can post a reply" do
          # FIXME: This is only necessary because of how current_user is mocked in sign_in!.
          # Once that's fixed this can go away and the spec should pass.
          User.delete_all

          fill_in "Text", :with => "Witty and insightful commentary."
          click_button "Post Reply"
          flash_notice!("Your reply has been posted.")
          assert_seen("In reply to #{topic.posts.first.user}", :within => :second_post)
        end
      end

      context "to a locked topic" do
        it "cannot post a reply" do
          # FIXME: This is only necessary because of how current_user is mocked in sign_in!.
          # Once that's fixed this can go away and the spec should pass.
          User.delete_all

          topic.lock_topic!

          fill_in "Text", :with => "Witty and insightful commentary."
          click_button "Post Reply"
          flash_alert!("You cannot reply to a locked topic.")
        end
      end

      it "cannot post a reply to a topic with blank text" do
        click_button "Post Reply"
        flash_alert!("Your reply could not be posted.")
      end

      it "does not hold over failed post flash to next request" do
        click_button "Post Reply"
        flash_alert!("Your reply could not be posted.")
        visit root_path
        page.should_not have_content("Your reply could not be posted.")
      end
    end

    context "deleting posts in topics" do
      before do
        sign_in!
      end

      context "topic contains two posts" do
        before do
          topic.posts << FactoryGirl.create(:post, :user => FactoryGirl.create(:user, :login => 'other_forem_user'))

          visit forum_topic_path(forum, topic)
        end

        it "can delete their own post" do
          within(selector_for(:first_post)) do
            click_link("Delete")
          end
          flash_notice!("Your post has been deleted.")
        end

      end

      context "topic contains one post" do
        before do
          visit forum_topic_path(forum, topic)
        end

        it "topic is deleted if only post" do
          Forem::Topic.count.should == 1
          within(selector_for(:first_post)) do
            click_link("Delete")
          end
          Forem::Topic.count.should == 0

          flash_notice!("Only post in topic deleted. Topic also deleted.")
        end
      end

    end
  end
end
