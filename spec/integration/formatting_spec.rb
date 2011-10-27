require 'spec_helper'

describe "When a post is displayed " do
  let(:forum) { FactoryGirl.create(:forum) }
  let(:topic) { FactoryGirl.create(:topic, :forum => forum, :posts => [post]) }
  let(:post) { FactoryGirl.create(:post)}

  describe "default formater" do
    it "renders untagged plain text" do
      visit forum_topic_path(forum, topic)
      # Regression test for #72
      within(".contents") do
        page.should_not have_css("pre")
      end

      page.should have_content(post.text)
    end

    it "does not render HTML tags in post text" do
      post.text = '<a href="http://localhost">click me</a>'; post.save!
      visit forum_topic_path(forum, topic)
      page.should_not have_xpath('//a[text()="click me"]')
    end
  end
end