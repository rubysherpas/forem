require 'spec_helper'

describe 'forum permissions' do
  let!(:forum) { Factory(:forum) }

  it "can't see forums it can't access" do
    User.any_instance.stub(:can_read_forem_forums?).and_return(false)
    visit forums_path
    page!
    page.should_not have_content("Welcome to Forem!")
  end

  context "without ability to read all forums" do
    before do
      User.any_instance.stub(:can_read_forem_forums?).and_return(false)
    end

    it "is denied access" do
      visit forum_path(forum.id)
      access_denied!
    end
  end

  context "without ability to read a specific forum" do
    before do
      User.any_instance.stub(:can_read_forem_forum?).and_return(false)
    end

    it "is denied access" do
      visit forum_path(forum.id)
      access_denied!
    end
  end

  context "with default permissions" do
    before do
      visit forum_path(forum.id)
    end

    it "shows the title" do
      within("#forum h2") do
        page.should have_content("Welcome to Forem!")
      end
      within("#forum small") do
        page.should have_content("A placeholder forum.")
      end
    end
  end
end
