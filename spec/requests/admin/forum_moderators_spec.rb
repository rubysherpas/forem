require 'spec_helper'

describe "forum moderators" do
  before do
    sign_in(Factory(:admin))
    Factory(:user, :login => "bob")
    Factory(:forum)

    visit root_path
    click_link "Admin Area"
    click_link "Forums"
    click_link "Moderators"
  end

  it "can assign a group as a moderator", :js => true do
    pending
  end
end
