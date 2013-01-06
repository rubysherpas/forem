require 'spec_helper'

describe "managing forums" do
  context "users not signed in as an admin" do
    before do
      user = FactoryGirl.create(:user)
      sign_in(user)
    end

    it "cannot create a new forum" do
      visit new_admin_forum_path
      flash_alert!("Access denied.")
    end
  end

  context "users signed in as admins" do
    let!(:forum) { FactoryGirl.create(:forum, :title => "Original Name") }
    before do
      admin = FactoryGirl.create(:admin)
      sign_in(admin)
      visit root_path
      # Ensure that people can navigate to this area.
      click_link "Admin Area"
      click_link "Forums"
    end

    context "creating a forum" do
      before do
        click_link "New Forum"
      end

      it "is valid with title and description" do
        category = FactoryGirl.create(:category)
        fill_in "Title", :with => "FIRST FORUM"
        fill_in "Description", :with => "The first placeholder forum."

        select category.name, :from => "forum_category_id"
        click_button 'Create Forum'

        flash_notice!("This forum has been created.")
      end

      it "is invalid without title" do
        fill_in "Description", :with => "The first placeholder forum."
        click_button 'Create Forum'

        flash_alert!("This forum could not be created.")
        find_field("forum_title").value.should be_blank
      end

      it "is invalid without description" do
        fill_in "Title", :with => "FIRST FORUM."
        click_button 'Create Forum'

        flash_alert!("This forum could not be created.")
        find_field("forum_description").value.chomp.should be_blank
      end

      it "does not keep fail flash message for next request" do
        fill_in "Title", :with => ""
        click_button 'Create Forum'
        flash_alert!("This forum could not be created.")
        visit root_path
        # page.should_not have_content("This forum could not be created.")
        page.html.should_not match("This forum could not be created.")
      end
    end

    context "working with a forum" do

      it "editing a forum" do
        click_link "Edit"
        fill_in "Title", :with => "New Name"
        click_button "Update Forum"
        assert_seen("That forum has been updated.")
      end

      it "cannot edit a forum to be invalid" do
        click_link "Edit"
        fill_in "Title", :with => ""
        click_button "Update Forum"
        assert_seen("This forum could not be updated.")
      end

      it "does not keep failed update notice across request" do
        click_link "Edit"
        fill_in "Title", :with => ""
        click_button "Update Forum"
        flash_alert!("This forum could not be updated.")
        visit root_path
        # page.should_not have_content("This forum could not be updated.")
        page.html.should_not match("This forum could not be updated.")
      end

      it "deleting a forum" do
        click_link "Delete"
        assert_seen("The selected forum has been deleted.")
      end
    end
  end
end
