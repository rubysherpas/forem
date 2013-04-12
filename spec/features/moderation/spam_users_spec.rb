require 'spec_helper'
describe "moderation" do
  let(:forum) { FactoryGirl.create(:forum) }
  let(:user) { FactoryGirl.create(:user) }

  context "spam users" do
    before do
      sign_in(user)
      User.any_instance.stub(:forem_state).and_return("spam")
    end

    it "cannot start a new topic" do
      visit forum_path(forum)
      click_link "New topic"
      flash_alert!("Your account has been flagged for spam. You cannot create a new topic at this time.")
    end

    it "cannot reply to a topic" do
      topic = FactoryGirl.create(:approved_topic, :forum => forum)
      visit forum_topic_path(forum, topic)

      within("menu") do
        click_link "Reply"
      end

      flash_alert!("Your account has been flagged for spam. You cannot create a new post at this time.")
    end
  end
end
