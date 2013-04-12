require 'spec_helper'

describe "topics" do

  let(:forum) { FactoryGirl.create(:forum) }
  let(:user) { FactoryGirl.create(:user, :login => 'other_forem_user', :email => "bob@boblaw.com", :custom_avatar_url => 'avatar.png') }
  let(:topic) { FactoryGirl.create(:approved_topic, :forum => forum, :user => user) }
  let(:other_user) { FactoryGirl.create(:user, :login => 'other_forem_user') }
  let(:other_topic) { FactoryGirl.create(:approved_topic, :subject => 'Another forem topic', :user => other_user, :forum => forum) }

  context "not signed in" do
    it "cannot create a new topic" do
      visit new_forum_topic_path(forum)
      flash_alert!("You must sign in first.")
    end
  end

  context "signed in" do
    before do
      sign_in(user)
      visit new_forum_topic_path(forum)
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

        flash_alert!("This topic could not be created.")
        find_field("topic_subject").value.should be_blank
        find_field("topic_posts_attributes_0_text").value.chomp.should eql("")
      end

      it "does not keep flash error over requests" do
        click_button 'Create Topic'
        flash_alert!("This topic could not be created.")
        visit root_path
        # page.should_not have_content("This topic could not be created.")
        page.html.should_not match("This topic could not be created.")
      end

      it "can delete their own topics" do
        visit forum_topic_path(topic.forum, topic)
        within(selector_for(:topic_menu)) do
          click_link("Delete")
        end
        flash_notice!("Your topic has been deleted.")
      end

      it "can subscribe to a topic" do
        visit forum_topic_path(other_topic.forum, other_topic)
        within(selector_for(:topic_menu)) do
          click_link("Subscribe")
        end
        flash_notice!("You have subscribed to this topic.")
        page.should have_content("Unsubscribe")
      end

      it "can unsubscribe from an subscribed topic" do
        other_topic.subscribe_user(user.id)
        visit forum_topic_path(other_topic.forum, other_topic)
        within(selector_for(:topic_menu)) do
          click_link("Unsubscribe")
        end
        flash_notice!("You have unsubscribed from this topic.")
        page.should have_content("Subscribe")
      end

      it "cannot delete topics by others" do
        visit forum_topic_path(other_topic.forum, other_topic)
        within(selector_for(:topic_menu)) do
          # page.should_not have_content("Delete")
          page.html.should_not match("Delete")
        end
      end

      # Regression test for #100
      it "can delete topics by others if an admin" do
        topic.user = FactoryGirl.create(:user) # Assign alternate user
        topic.save

        user.update_attribute(:forem_admin, true)
        visit forum_topic_path(topic.forum, topic)
        within(selector_for(:topic_menu)) do
          click_link("Delete")
        end
        flash_notice!("Your topic has been deleted.")
      end

      context "creating a topic" do
        it "creates a view" do
          lambda do
            visit forum_topic_path(forum, topic)
          end.should change(Forem::View, :count).by(1)
        end

        it "increments a view" do
          # register a view
          visit forum_topic_path(forum, topic)

          # expect does not work as expected.
          # the view object is not reloaded when it's re-checked, but cached instead
          # Therefore we cannot do this:
          #
          # expect do
          #   visit forum_topic_path(forum, topic)
          # end.to change(view.reload, :count)
          #
          # But instead must go long-form:

          view = ::Forem::View.last
          view.count.should eql(1)
          visit forum_topic_path(forum, topic)
          view.reload.count.should eql(2)
        end
      end
    end
  end

  context "viewing a topic" do
    let(:topic) do
      FactoryGirl.create(:approved_topic, :forum => forum, :user => user)
    end

    it "is free for all" do
      visit forum_topic_path(forum, topic)
      assert_seen(topic.subject, :within => :topic_header)
      assert_seen(topic.posts.first.text, :within => :post_text)
    end

    it "should show an avatar from gravatar" do
      visit forum_topic_path(forum, topic)
      assert page.has_selector?("div.icon > img[alt='Avatar']")
    end

    it "should show a custom avatar when set" do
      Forem.stub(:avatar_user_method => "custom_avatar_url")

      visit forum_topic_path(forum, topic)
      assert page.has_selector?("div.icon > img[alt='Avatar']")
    end

    it "should show no avatar with custom method empty" do
      Forem.stub(:avatar_user_method => "custom_avatar_url")

      visit forum_topic_path(forum, other_topic)
      assert page.has_no_selector?("div.icon > img[alt='Avatar']")
    end

    it "should have an autodiscover link tag" do
      visit forum_topic_path(forum, topic)
      assert page.has_selector?("link[title='ATOM']")
    end
  end
end
