require 'spec_helper'

describe "posts" do
  let(:forum) { FactoryGirl.create(:forum) }
  let(:user) { FactoryGirl.create(:user) }
  let(:topic) { FactoryGirl.create(:approved_topic, :forum => forum, :forem_user => user) }

  context "not signed in users" do
    it "cannot begin to post a reply" do
      visit new_forum_topic_post_path(topic.forum, topic)
      flash_alert!("You must sign in first.")
    end
  end

  context "posts with deleted users" do
    it "can be viewed" do
      first_post = topic.posts.first
      first_post.update_column(:user_id, nil)
      visit forum_topic_path(forum, topic)
      expect(page).to have_content(topic.subject)
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

      context "to a topic with multiple pages" do
        it "redirects to the last page" do
          allow(Forem).to receive(:per_page).and_return(1)

          fill_in "Text", :with => "Witty and insightful commentary."
          click_button "Post Reply"

          expect(page).to have_content("Witty and insightful commentary")
          expect(page).not_to have_content(topic.posts.first.text)
        end
      end

      context "to an unlocked topic" do
        it "shows the topic we are replying to" do
          expect(page).to have_content(topic.posts.first.text)
        end

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
        expect(page).not_to have_content("Your reply could not be posted.")
      end
    end

    context "quoting" do
      it "cannot quote deleted post" do
        other_user = FactoryGirl.create(:user, :login => 'other_forem_user', :email => "maryanne@boblaw.com")
        topic.posts << FactoryGirl.build(:approved_post, :user => other_user)
        @second_post = topic.posts[1]

        visit forum_topic_path(forum, topic)
        @second_post.delete

        within(selector_for(:second_post)) do
          click_link("Quote")
        end

        flash_notice!(I18n.t("forem.post.cannot_quote_deleted_post"))
      end
    end

    context "editing posts in topics" do
      before do
        other_user = FactoryGirl.create(:user, :login => 'other_forem_user', :email => "maryanne@boblaw.com")
        topic.posts << FactoryGirl.build(:approved_post, :user => other_user)
        @second_post = topic.posts[1]
      end

      it "can edit their own post" do
        visit forum_topic_path(forum, topic)
        within(selector_for(:first_post)) do
            click_link("Edit")
        end
        fill_in "Text", :with => "this is my edit"
        click_button "Edit"
        flash_notice!("Your post has been edited")
        expect(page).to have_content("this is my edit")
      end

      it "should not allow you to edit a post you don't own" do
        # second_post = topic.posts[1]
        visit edit_forum_topic_post_path(forum, topic, @second_post)
        fill_in "Text", :with => "an evil edit"
        click_button "Edit"
        flash_alert!("Your post could not be edited")
      end

      it "should not display edit link on posts you don't own" do
        visit forum_topic_path(forum, topic)

        # all("#post_#{@second_post.id} ul.actions a").each do |a|
        #   a.should_not have_content("Edit")
        # end
        expect(all("#post_#{@second_post.id} ul.actions a").map do |a|
          a.native.children.first.text
        end).not_to include("Edit")
      end

      it "should display edit link on posts you own" do
        visit forum_topic_path(forum, topic)
        within(selector_for(:first_post)) do
          expect(page).to have_content("Edit")
        end
      end
    end

    context "deleting posts in topics" do
      context "topic contains two posts" do
        before do
          topic.posts << FactoryGirl.build(:approved_post, :created_at => 1.day.from_now, :user => FactoryGirl.create(:user, :login => 'other_forem_user', :email => "maryanne@boblaw.com"))

        end

        it "shows correct 'started by' and 'last post' information" do
          visit forum_path(forum)
          within(".topic .started-by") do
            expect(page).to have_content("forem_user")
          end

          within(".topic .latest-post") do
            expect(page).to have_content("other_forem_user")
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
          Capybara.current_session.driver.submit :delete, forum_topic_post_path(forum, topic, other_post), {}
          flash_alert!("You cannot delete a post you do not own.")
          expect(::Forem::Post).to exist(other_post.id)
        end
      end

      context "topic contains one post" do
        before do
          visit forum_topic_path(forum, topic)
        end

        it "topic is deleted if only post" do
          expect(Forem::Topic.count).to eq(1)
          within(selector_for(:first_post)) do
            click_link("Delete")
          end
          expect(Forem::Topic.count).to eq(0)

          flash_notice!("Only post in topic deleted. Topic also deleted.")
        end
      end

    end
  end
end
