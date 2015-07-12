require 'spec_helper'

describe Forem::ModerationController do
  use_forem_routes

  before do
    controller.stub :forum => stub_model(Forem::Forum)
    controller.stub :forem_admin? => false
  end

  it "anonymous users cannot access moderation" do
    get :index, forum_id: 1
    flash[:alert].should == "You are not allowed to do that."
  end

  it "normal users cannot access moderation" do
    controller.stub_chain "forum.moderator?" => false

    get :index, forum_id: 1
    flash[:alert].should == "You are not allowed to do that."
  end

  it "moderators can access moderation" do
    controller.stub_chain "forum.moderator?" => true
    get :index, forum_id: 1
    flash[:alert].should be_nil
  end

  it "admins can access moderation" do
    controller.stub :forem_admin? => true
    get :index, forum_id: 1
    flash[:alert].should be_nil
  end

  # Regression test for #238
  it "is prompted to select an option when no option selected" do
    @request.env['HTTP_REFERER'] = Capybara.default_host
    controller.stub :forem_admin? => true
    put :topic, forum_id: 1, topic_id: 1
    flash[:error].should == I18n.t("forem.topic.moderation.no_option_selected")
  end

end
