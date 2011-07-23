require 'spec_helper'

describe 'authentication' do
  context "anonymous users" do
    it "cannot access admin area" do
      visit admin_root_path
      flash_error!("Access denied.")
    end
  end

  context "admin users" do
    before do
      sign_in! :admin => true
    end

    it "can access admin area" do
      visit admin_root_path
      page.should_not have_content("Access denied.")
    end
  end
end