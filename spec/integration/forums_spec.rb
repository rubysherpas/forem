require 'spec_helper'

describe "forums" do
  let!(:forum) { Factory(:forum) }

  it "listing all" do
    visit forums_path
    page.should have_content("Welcome to Forem!")
    page.should have_content("A placeholder forum.")

  end

  context "visiting a forum" do
    before do
      @topic_1 = Factory(:topic, :subject => "Unpinned", :forum => forum)
      @topic_2 = Factory(:topic, :subject => "Most Recent", :forum => forum)
      Factory(:post, :topic => @topic_2, :created_at => Time.now + 30.seconds)
      @topic_3 = Factory(:topic, :subject => "PINNED!", :forum => forum, :pinned => true)
      visit forum_path(forum.id)
    end

    it "shows the title" do
      within("#forum h2") do
        page.should have_content("Welcome to Forem!")
      end
    end

    it "lists pinned topics first" do
      # TODO: cleaner way to get at topic subjects on the page?
      topic_subjects = Nokogiri::HTML(page.body).css(".topics tbody tr .subject").map(&:text)
      topic_subjects.should == ["PINNED!", "Most Recent", "Unpinned"]
    end
  end
end
