require 'spec_helper'

describe 'groups' do
  before do
    sign_in(Factory(:admin))
  end

  context "creating a group" do
    before do
      visit root_path
      click_link "Admin Area"
      click_link "Manage Groups"
      click_link "New Group"
    end

    it "is valid with a name" do
      fill_in "Name", :with => "Special People"
      click_button 'Create Group'
      flash_notice!("The group was successfully created.")
      page.current_url.should == admin_group_url(Forem::Group.find_by_name("Special People"))
    end

    it "is invalid without a name" do
      click_button "Create Group"
      flash_alert!("Group could not be created.")
    end
  end
end
