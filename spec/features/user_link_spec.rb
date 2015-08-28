require 'spec_helper'

# Test for #83
describe "user links" do
  let(:topic) { FactoryGirl.create(:approved_topic) }
  let(:post) { FactoryGirl.create(:approved_post, :topic => topic) }

  context "with user_profile_links on" do
    before { Forem.user_profile_links = true }
    after { Forem.user_profile_links = false }

    it "is able to click a user link" do
      visit forum_topic_path(post.forum, post.topic)

      # There should be at least one link on the page with the user's name
      first(:link, post.user.forem_name).click

      expect(page).to have_content("A user's page!")
    end
  end

  context "with user_profile_links off" do
    before { Forem.user_profile_links = false }

    it "user name is not a link" do
      visit forum_topic_path(post.forum, post.topic)
      # There should be no links on the page with the user's name
      Nokogiri::HTML(page.body).css("a").none? { |a| a.text.include?(post.user.forem_name) }
    end
  end
end
