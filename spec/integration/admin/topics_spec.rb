require 'spec_helper'

describe "topics" do
  let(:forum) { Factory(:forum) }
  let(:topic) { Factory(:topic, :forum => forum) }

  before do
    sign_in! :admin => true
  end

  it "can hide a topic" do
    visit forum_topic_path(forum, topic)
    click_link "Hide"
    page!
    flash_notice!("This topic is now hidden.")

    sign_out!

    visit forum_topic_path(forum, topic)
    flash_error!("The topic you are looking for could not be found.")
  end
end