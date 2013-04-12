require 'spec_helper'

describe "When a post is displayed " do
  let(:forum) { FactoryGirl.create(:forum) }
  let(:topic) { FactoryGirl.create(:approved_topic, :forum => forum) }
  let!(:post) { FactoryGirl.create(:approved_post, :topic => topic) }

  describe "default formatter" do
    it "renders untagged plain text" do
      visit forum_topic_path(forum, topic)
      # Regression test for #72
      page.all(".contents").each do |div|
        div.should_not have_css("pre")
      end

      page.should have_content(post.text)
    end

    it "does not render HTML tags in post text" do
      post.text = '<a href="http://localhost">click me</a>'
      post.save!
      visit forum_topic_path(forum, topic)
      page.should_not have_xpath('//a[text()="click me"]')
    end
  end

  describe "rdiscount formatter" do
    before {
      # MRI-specific C-extention tests
      if Forem::Platform.mri?
        Forem.formatter = Forem::Formatters::Redcarpet
      else
        Forem.formatter = Forem::Formatters::Kramdown
      end
    }
    after { Forem.formatter = nil }

    it "renders marked up text" do
      post.text = "**strong text goes here**"
      post.save!
      visit forum_topic_path(forum, topic)

      within("strong") do
        page.should have_content("strong text goes here")
      end
    end

    it "does not render HTML tags in post text" do
      post.text = '<a href="http://localhost">click me</a>'
      post.save!
      visit forum_topic_path(forum, topic)
      page.should_not have_xpath('//a[text()="click me"]')
    end

    it "does not escape blockquotes" do
      post.text = "> **strong text**\n\n"
      post.save!
      visit forum_topic_path(forum, topic)

      within("blockquote strong") do
        page.should have_content("strong text")
      end
    end
  end
end
