require 'spec_helper'

describe "posts" do
  let(:forum) { FactoryGirl.create(:forum) }
  let(:user) { FactoryGirl.create(:user) }
  let(:topic) { FactoryGirl.create(:topic, :forum => forum, :user => user) }
  
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
    before do
      sign_in(user)
      visit forum_topic_path(forum, topic)
    end

    context "replying" do
      before do
        within(selector_for(:first_post)) do
          click_link("Reply")
        end
      end

      context "to an unlocked topic" do
        it "can post a reply" do
          fill_in "Text", :with => "Witty and insightful commentary."
          click_button "Post Reply"
          flash_notice!("Your reply has been posted.")
          assert_seen("In reply to #{topic.posts.first.user.login}", :within => :second_post)
          click_link "Welcome to Forem!"
        end
      end

      context "to a locked topic" do
        it "cannot post a reply" do
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
        sign_in(user)
      end

      context "topic contains two posts" do
        before do
          topic.posts << FactoryGirl.create(:post, :user => FactoryGirl.create(:user, :login => 'other_forem_user', :email => "maryanne@boblaw.com"))

        end

        it "shows correct 'started by' and 'last post' information" do
          visit forum_path(forum)
          within(".topic .started-by") do
            page.should have_content("forem_user")
          end

          within(".topic .latest-post") do
            page.should have_content("other_forem_user")
          end
        end

        it "can delete their own post" do
          visit forum_topic_path(forum, topic)
          within(selector_for(:first_post)) do
            click_link("Delete")
          end
          flash_notice!("Your post has been deleted.")
        end

        it "cannot delete posts by others" do
          visit forum_topic_path(forum, topic)
          other_post = topic.posts[1]
          #sends delete request with the current rack-test logged-in session & follows the redirect
          Capybara.current_session.driver.submit :delete, topic_post_path(topic, other_post), {}
          flash_alert!("You cannot delete a post you do not own.")
          ::Forem::Post.should exist(other_post.id)
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
