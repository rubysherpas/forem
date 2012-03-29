require 'spec_helper'

describe "forum moderators" do
  before do
    sign_in(Factory(:admin))
    user = Factory(:user, :login => "bob")
    group = Factory(:group, :name => "The Mods")
    group.members << user

    forum = Factory(:forum)

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
