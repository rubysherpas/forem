require 'spec_helper'

describe "topics" do
  let(:forum) { FactoryGirl.create(:forum) }
  let(:topic) { FactoryGirl.create(:topic, :forum => forum) }
  let(:other_topic) { FactoryGirl.create(:topic, :forum => forum, :subject => "SECOND TOPIC") }

  before do
    sign_in! :admin => true
  end

  it "can hide a topic" do
    visit forum_topic_path(forum, topic)
    click_link "Hide"
    flash_notice!("This topic is now hidden.")

    sign_out!

    visit forum_topic_path(forum, topic)
    flash_error!("The topic you are looking for could not be found.")
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

    sign_out!
    sign_in!

    visit forum_topic_path(forum, topic)
    page.should_not have_content("New Topic")
  end

  it "can pin a topic" do
    visit forum_topic_path(forum, topic)
    click_link "Pin"
    flash_notice!("This topic is now pinned.")

    other_topic # will create another topic, making it the top post unless the first topic is truly pinned
    visit forum_path(forum)
    page.all(".topics .subject").map(&:text).should == ["FIRST TOPIC", "SECOND TOPIC"]
  end
end
