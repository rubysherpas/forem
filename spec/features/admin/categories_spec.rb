require 'spec_helper'

describe "managing categories" do
  context "users not signed in as an admin" do
    before do
      user = FactoryGirl.create(:user)
      sign_in(user)
    end

    it "cannot create a new category" do
      visit new_admin_forum_path
      flash_alert!("Access denied.")
    end
  end

  context "users signed in as admins" do
    before do
      admin = FactoryGirl.create(:admin)
      sign_in(admin)
      visit root_path
      # Ensure that people can navigate to this area.
      click_link "Admin Area"
      click_link "Categories"
    end

    context "creating a forum" do
      before do
        click_link "New Forum Category"
      end

      it "successfully" do
        fill_in "Name", :with => "Categorical"
        click_button "Create Category"
        flash_notice!("This forum category has been created.")
      end
    end
  end
end
