require 'spec_helper'

describe 'post permissions' do
  let(:forum) { FactoryGirl.create(:forum) }
  let(:user) { FactoryGirl.create(:user) }
  let(:topic) { FactoryGirl.create(:topic, :forum => forum, :user => user) }


  context "without permission to reply" do
    before do
      sign_in(user)
      allow_any_instance_of(User).to receive(:can_reply_to_forem_topic?).and_return(false)
    end

    it "users can't see the link to reply" do
      visit forum_topic_path(forum, topic)
      assert_no_link_for!("Reply")
    end
  end

  context "with default permissions" do
    before do
      sign_in(user)
    end

    it "users can see the reply, edit, and delete links" do
      visit forum_topic_path(forum, topic)
      expect(page).to have_selector("a", :text => "Reply")
      expect(page).to have_selector("a", :text => "Edit")
      expect(page).to have_selector("a", :text => "Delete")
    end

  end
end
