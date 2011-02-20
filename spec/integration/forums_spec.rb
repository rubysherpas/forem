require 'spec_helper'

describe "forums" do
  before do
    @forum = Forem::Forum.create(:title => "Welcome to Forem!",
                                 :description => "A placeholder forum.")
  end

  it "lists all forums" do
    visit forem_forums_path
    p page.save_and_open_page
    page.should have_content("Welcome to Forem!")
    page.should have_content("A placeholder forum.")
  end
end