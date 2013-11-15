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

    it "does render a tags in post text" do
      post.text = '<a href="http://localhost">click me</a>'
      post.save!
      visit forum_topic_path(forum, topic)
      xpath = '//a[text()="click me"]'
      a_tag = all(".post .contents a").detect { |a| a.text == "click me" }
      a_tag.should_not be_nil
      a_tag['rel'].should == "nofollow"
    end

    # Regression test for #359
    it "renders blockquote tags just fine" do
      post.text = 'And then I said: <blockquote>You know what?</blockquote>'
      post.save!
      visit forum_topic_path(forum, topic)
      all(".post").last.find("blockquote").text.should == "You know what?"
    end

    # Regression test for #359
    it "renders blockquote without p tag wrapping" do
      post.text = '<blockquote>You know what?</blockquote>'
      post.save!
      visit forum_topic_path(forum, topic)
      lambda { all(".post").last.find(".contents p") }.should raise_error(Capybara::ElementNotFound)
    end

    it "does not render script tags in post text" do
      post.text = '<a href="http://localhost">click me</a>'
      post.save!
      visit forum_topic_path(forum, topic)
      lambda { all(".post")[1].find("script") }.should raise_error(Capybara::ElementNotFound)
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

    it "renders a tags just fine" do
      post.text = '<a href="http://localhost">click me</a>'
      post.save!
      visit forum_topic_path(forum, topic)
      page.should have_xpath('//a[text()="click me"]')
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
