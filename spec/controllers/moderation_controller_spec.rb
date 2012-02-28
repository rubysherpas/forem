require 'spec_helper'

describe Forem::ModerationController do
  before do
    controller.stub :forum => stub_model(Forem::Forum)
    controller.stub :forem_admin? => false
  end

  it "anonymous users cannot access moderation" do
    get :index
    flash[:alert].should == "You are not allowed to do that."
  end

  it "normal users cannot access moderation" do
    controller.stub_chain "forum.moderator?" => false

    get :index
    flash[:alert].should == "You are not allowed to do that."
  end

  it "moderators can access moderation" do
    controller.stub_chain "forum.moderator?" => true
    get :index
    flash[:alert].should be_nil
  end

  it "admins can access moderation" do
    controller.stub :forem_admin? => true
    get :index
    flash[:alert].should be_nil
  end

end
