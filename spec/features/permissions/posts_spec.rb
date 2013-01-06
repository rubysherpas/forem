require 'spec_helper'

describe 'post permissions' do
  let(:forum) { FactoryGirl.create(:forum) }
  let(:user) { FactoryGirl.create(:user) }
  let(:topic) { FactoryGirl.create(:topic, :forum => forum, :user => user) }


  context "without permission to reply" do
    before do
      sign_in(user)
      User.any_instance.stub(:can_reply_to_forem_topic?).and_return(false)
    end

    it "users can't see the link to reply" do
      visit forum_topic_path(forum, topic)
      assert_no_link_for!("Reply")
    end

    it "cannot create new reply" do
      visit new_topic_post_path(topic)
      access_denied!
    end
  end

  context "with, but then without permission to reply" do
    before do
      sign_in(user)
    end

    it "cannot create a new reply" do
      visit new_topic_post_path(topic)
      fill_in "Text", :with => "REPLYING!"
      User.any_instance.stub(:can_reply_to_forem_topic?).and_return(false)
      click_button "Reply"
      access_denied!
    end
  end

  context "without permission to edit" do
    before do
      sign_in(user)
      User.any_instance.stub(:can_edit_forem_posts?).and_return(false)
    end

    it "can't see edit post link" do
      visit forum_topic_path(forum, topic)
      within(selector_for(:first_post)) do
          assert_no_link_for!("Edit")
      end
    end

    it "can't edit a post" do
      first_post = topic.posts[0]
      visit edit_topic_post_path(topic, first_post)
      access_denied!
    end
  end

  context "with default permissions" do
    before do
      sign_in(user)
    end

    it "users can see the link to reply" do
      visit forum_topic_path(forum, topic)

      within("menu") do
        click_link "Reply"
      end

      page.current_path.should == new_topic_post_path(topic)
    end
  end
end
