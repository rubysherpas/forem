require 'spec_helper'

describe "forums" do
  let!(:forum) { Factory(:forum) }

  it "listing all" do
    visit forem_forums_path
    page.should have_content("Welcome to Forem!")
    page.should have_content("A placeholder forum.")

  end

  it "visiting one" do
    visit forem_forum_path(forum.id)
    within("#forum h2") do
      page.should have_content("Welcome to Forem!")
    end
  end
  
  context "not signed in admins" do
    before do
      sign_in!
    end
    
    it "cannot create a new forum" do
      visit new_forem_forum_path
      flash_error!("Access denied.")
    end
  end
  
  context "signed in admins" do
    before do
      sign_in! :admin => true
      visit new_forem_forum_path
    end

    context "creating a forum" do
      it "is valid with title and description" do
        fill_in "Title", :with => "FIRST FORUM"
        fill_in "Description", :with => "The first placeholder forum."
        click_button 'Create Forum'

        flash_notice!("This forum has been created.")
        assert_seen("FIRST FORUM", :within => :forum_header)
        assert_seen("The first placeholder forum.", :within => :forum_description)
      end

      it "is invalid without title" do
        fill_in "Description", :with => "The first placeholder forum."
        click_button 'Create Forum'

        flash_error!("This forum could not be created.")
        find_field("forem_forum_title").value.should eql("")
      end
      
      it "is invalid without description" do
        fill_in "Title", :with => "FIRST FORUM."
        click_button 'Create Forum'

        flash_error!("This forum could not be created.")
        find_field("forem_forum_description").value.should eql("")
      end
    end
  end
end