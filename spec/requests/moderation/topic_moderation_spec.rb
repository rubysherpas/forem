require 'spec_helper'

describe "moderation" do
  context" of topics" do
    let!(:moderator) { Factory(:user, :login => "moderator") }
    let!(:group) do
      group = Factory(:group)
      group.members << moderator
      group.save!
      group
    end

    let!(:forum) { Factory(:forum) }
    let!(:topic) { Factory(:topic, :forum => forum) }

    before do
      forum.moderators << group
      sign_in(moderator)
    end

    context "singular moderation" do
      it "can approve a topic by a new user" do
        visit forum_topic_path(forum, topic)
        within("#topic_moderation") do
          choose "Approve"
          click_button "Moderate"
        end
        flash_notice!("The selected topic has been moderated.")
        page.should_not have_content("This topic is currently pending review.")
      end
    end
  end
end
