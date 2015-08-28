require 'spec_helper'

describe 'groups' do
  before do
    sign_in(FactoryGirl.create(:admin))
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
      expect(page.current_path).to eq(admin_group_path(
        Forem::Group.find_by_name("Special People")
      ))
    end

    it "is invalid without a name" do
      click_button "Create Group"
      flash_alert!("Group could not be created.")
    end
  end

  context "deleting a group" do
    before do
      FactoryGirl.create(:group)
      visit admin_groups_path
    end

    specify do
      click_link "Delete"
      flash_notice!("The selected group has been deleted.")
    end
  end
  
  context "removing user from the group" do
    before do
      user = FactoryGirl.create(:user)
      group = FactoryGirl.create(:group)
      group.members << user
      visit admin_group_path(Forem::Group.find_by_id(group.id))
    end

    specify do
      click_link "Remove member"
      flash_notice!("The selected user has been removed from the group.")
    end
  end
end
