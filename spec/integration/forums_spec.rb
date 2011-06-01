require 'spec_helper'

describe "forums" do
  let!(:forum) { Factory(:forum) }

  it "listing all" do
    visit forums_path
    page.should have_content("Welcome to Forem!")
    page.should have_content("A placeholder forum.")

  end

  it "visiting one" do
    visit forum_path(forum.id)
    within("#forum h2") do
      page.should have_content("Welcome to Forem!")
    end
  end
end
