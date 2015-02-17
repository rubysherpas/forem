require 'spec_helper'
describe "moderation" do
  let(:forum) { FactoryGirl.create(:forum) }
  let(:user) { FactoryGirl.create(:user) }

  context "of posts" do
    let!(:moderator) { FactoryGirl.create(:user, :login => "moderator") }
    let!(:group) do
      group = FactoryGirl.create(:group)
      group.members << moderator
      group.save!
      group
    end

    let!(:forum) { FactoryGirl.create(:forum) }
    let!(:topic) { FactoryGirl.create(:topic, :forum => forum) }
    let!(:post) { FactoryGirl.create(:post, :topic => topic) }

    before do
      forum.moderators << group
      sign_in(moderator)
      topic.approve!
    end

    context "mass moderation" do
      it "can approve a post by a new user" do

        visit forum_path(forum)
        click_link "Moderation Tools"

        choose "Approve"
        first(:button, "Moderate").click

        flash_notice!("The selected posts have been moderated.")
        post.reload
        expect(post).to be_approved
        expect(post.user.reload.forem_state).to eq("approved")
      end

      it "can mark a post as spam" do
        visit forum_path(forum)
        click_link "Moderation Tools"

        choose "Spam"
        first(:button, "Moderate").click

        flash_notice!("The selected posts have been moderated.")
        post.reload
        expect(post).to be_spam
        expect(post.user.reload.forem_state).to eq("spam")
      end
    end

    context "singular moderation" do
      it "can approve a post by a new user" do
        visit forum_topic_path(forum, topic)
        choose "Approve"
        click_button "Moderate"

        flash_notice!("The selected posts have been moderated.")
        expect(post.user.reload.forem_state).to eq("approved")
      end
    end
  end
end
