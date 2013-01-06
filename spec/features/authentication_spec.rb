require 'spec_helper'

describe 'authentication' do

  let(:forum) { FactoryGirl.create(:forum) }
  let(:user) { FactoryGirl.create(:user) }
  let(:topic) { FactoryGirl.create(:approved_topic, :forum => forum, :user => user) }

  context "anonymous users" do
    it "is redirected to main_app.sign_in_path by default" do
      visit forum_topic_path(forum, topic)
      click_link("Reply")
      page.current_path.should eq("/users/sign_in")
    end

    it "is redirected to configured path if configured" do
      Forem.sign_in_path = "/"
      visit forum_topic_path(forum, topic)
      click_link("Reply")
      page.current_path.should eq("/")
    end

    after do
      Forem.sign_in_path = nil
    end
  end
end
