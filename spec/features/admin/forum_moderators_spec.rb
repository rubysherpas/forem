require 'spec_helper'

describe "forum moderators" do
  before do
    sign_in(FactoryGirl.create(:admin))
    user = FactoryGirl.create(:user, :login => "bob")
    group = FactoryGirl.create(:group, :name => "The Mods")
    group.members << user

    forum = FactoryGirl.create(:forum)

    visit edit_admin_forum_path(forum)
  end

  it "can assign a group as a moderators" do
    check "The Mods"
    click_button "Update Forum"
    within(".forum .moderators") do
      page.should have_content("The Mods")
    end
  end
end
