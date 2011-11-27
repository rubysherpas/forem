require 'spec_helper'

describe 'post permissions' do
  let(:forum) { Factory(:forum) }
  let(:topic) { Factory(:topic, :forum => forum) }
  let(:user) { Factory(:user) }

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


  context "with default permissions" do
    before do
      sign_in(user)
    end

    it "users can see the link to reply" do
      visit forum_topic_path(forum, topic)
      click_link "Reply"
      page.current_url.should == new_topic_post_url(topic)
    end
  end
end
