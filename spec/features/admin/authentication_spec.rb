require 'spec_helper'

describe 'authentication' do
  context "anonymous users" do
    it "cannot access admin area" do
      visit admin_root_path
      flash_alert!("Access denied.")
    end
  end

  context "admin users" do
    before do
      user = FactoryGirl.create(:admin)
      sign_in(user)
    end

    it "can access admin area" do
      visit admin_root_path
      # page.should_not have_content("Access denied.")
      page.html.should_not match("Access denied.")
    end
  end
end
