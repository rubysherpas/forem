require 'spec_helper'

describe "moderation" do
  context" of topics" do
    let!(:moderator) { FactoryGirl.create(:user, :login => "moderator") }
    let!(:group) do
      group = FactoryGirl.create(:group)
      group.members << moderator
      group.save!
      group
    end

    let!(:forum) { FactoryGirl.create(:forum) }
    let!(:topic) { FactoryGirl.create(:topic, :forum => forum) }

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
