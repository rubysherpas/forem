require 'spec_helper'

describe "category permissions" do
  let!(:category) { FactoryGirl.create(:category) }
  let!(:forum) { FactoryGirl.create(:forum, :category => category) }

  context "without ability to read a category" do
    before do
      allow_any_instance_of(User).to receive(:can_read_forem_category?).and_return(false)
    end

    it "can't see the categories it can't access" do
      visit forums_path
      expect(page).not_to have_content("Welcome to Forem!")
    end

    it "can't visit a particular category" do
      visit category_path(category)
      access_denied!
    end
  end

  context "with default permissions" do
    it "can see the category" do
      visit root_path
      within(".category h2") do
        expect(page).to have_content("Test Category")
      end
    end
  end


end
