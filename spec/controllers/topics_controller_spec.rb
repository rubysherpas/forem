require 'spec_helper'

describe Forem::TopicsController do
  context "attempting to subscribe to a hidden topic" do
    before do
      sign_in(:user, Factory(:user))

      forum = stub_model(Forem::Forum)

      controller.should_receive(:authorize!).and_return(true)
      Forem::Forum.should_receive(:find).and_return(forum)
      forum.stub_chain("topics.visible.find").and_raise(ActiveRecord::RecordNotFound)
    end

    # Regression test for #122
    specify do
      get :subscribe, :forum_id => 1, :id => 1
      flash[:alert].should == "The topic you are looking for could not be found."
    end
  end
end
