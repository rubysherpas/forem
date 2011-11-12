require 'spec_helper'

describe "forums" do
  let!(:forum) { FactoryGirl.create(:forum) }

  it "listing all" do
    visit forums_path
    within(".forum") do
      page.should have_content("Welcome to Forem!")
      within(".description") do
        page.should have_content("A placeholder forum.")
      end
    end
  end

  context "visiting a forum" do
    before do
      @topic_1 = FactoryGirl.create(:topic, :subject => "Unpinned", :forum => forum)
      @topic_2 = FactoryGirl.create(:topic, :subject => "Most Recent", :forum => forum)
      FactoryGirl.create(:post, :topic => @topic_2, :created_at => Time.now + 30.seconds)
      @topic_3 = FactoryGirl.create(:topic, :subject => "PINNED!", :forum => forum, :pinned => true)
      @topic_4 = FactoryGirl.create(:topic, :subject => "HIDDEN!", :forum => forum, :hidden => true)
      visit forum_path(forum)
    end

    it "lists pinned topics first" do
      # TODO: cleaner way to get at topic subjects on the page?
      topic_subjects = Nokogiri::HTML(page.body).css(".topics tbody tr .subject").map(&:text)
      topic_subjects.should == ["PINNED!", "Most Recent", "Unpinned"]
    end

    it "does not show hidden topics" do
      # TODO: cleaner way to get at topic subjects on the page?
      topic_subjects = Nokogiri::HTML(page.body).css(".topics tbody tr .subject").map(&:text)
      topic_subjects.include?("HIDDEN!").should be_false
    end

    context "when logged in" do
      before do
        user = Factory(:user)
        sign_in(user)
      end
      it "calls out topics that have been posted to since your last visit, if you've visited" do
        visit forum_topic_path(forum.id, @topic_2)
        ::Forem::View.last.update_attribute(:updated_at, 1.minute.ago)
        visit forum_path(forum)
        topic_subjects = Nokogiri::HTML(page.body).css(".topics tbody tr .new_posts")
        topic_subjects.should_not be_empty
      end
    end
  end
end
