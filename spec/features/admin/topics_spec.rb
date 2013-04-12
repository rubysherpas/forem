require 'spec_helper'

describe "topics" do
  let(:category) { FactoryGirl.create(:category) }
  let(:forum) { FactoryGirl.create(:forum) }
  let(:topic) { FactoryGirl.create(:approved_topic, :forum => forum) }
  let(:other_topic) { FactoryGirl.create(:topic, :forum => forum, :subject => "SECOND TOPIC") }
  let(:other_forum) {FactoryGirl.create(:forum, :title => "Second Forum", :description => "A Forum", :category_id => category.id )}

  before do
    admin = FactoryGirl.create(:admin)
    sign_in(admin)
  end

  it "can hide a topic" do
    visit forum_topic_path(forum, topic)
    click_link "Hide"
    flash_notice!("This topic is now hidden.")

    sign_out

    visit forum_topic_path(forum, topic)
    flash_alert!("The topic you are looking for could not be found.")

    # Regression test for #42
    visit root_path
    # Sigh, do what I mean, not what I say.
    /Last Post:\s?None/.match(page.body)
  end

  # Regression test for #41
  it "can unhide a topic" do
    visit forum_topic_path(forum, topic)
    click_link "Hide"
    flash_notice!("This topic is now hidden.")

    visit forum_path(forum)

    # Ensures we can navigate back to the topic from the forum view
    # We should be able to see it because we're an admin
    click_link "FIRST TOPIC"
    click_link "Show this topic"
    flash_notice!("This topic is now visible.")
  end

  it "can lock a topic" do
    visit forum_topic_path(forum, topic)
    click_link "Lock"
    flash_notice!("This topic is now locked.")

    sign_out

    visit forum_topic_path(forum, topic)
    # page.should_not have_content("New Topic")
    page.html.should_not match("New Topic")
  end

  it "can pin a topic" do
    visit forum_topic_path(forum, topic)
    click_link "Pin"
    flash_notice!("This topic is now pinned.")

    other_topic # will create another topic, making it the top post unless the first topic is truly pinned
    visit forum_path(forum)

    # Capybara 2.0 #text method has issues on Ruby 1.8
    # page.all(".topics .topic .subject").map(&:text).should == ["FIRST TOPIC", "SECOND TOPIC"]

    page.all(".topics .topic .subject a").map do |a|
      a.native.children.first.text
    end.should == ["FIRST TOPIC", "SECOND TOPIC"]
  end

  it "can move topic" do
    other_forum #Create a second forum
    visit edit_admin_topic_path(topic)

    select "Second Forum", :from => "topic_forum_id"
    click_button "Update Topic"
    flash_notice!("This topic has been updated.")
    #Check if we can see the topic in the old forum, the topic should not be there.
    visit forum_topic_path(forum, topic)
    flash_alert!("The topic you are looking for could not be found.")
    #Visit Topic in New Forum
    visit forum_topic_path(other_forum, topic)
    page.should have_content("FIRST TOPIC")
  end
end
