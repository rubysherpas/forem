require 'spec_helper'

describe Forem::TopicsController do
  context "attempting to subscribe to a hidden topic" do
    let!(:forum) { create(:forum) }
    let!(:topic) { create(:topic) }
    before do
      user = FactoryGirl.create(:user)
      sign_in(user)
      controller.current_user.stub :can_read_topic? => false
    end

    # Regression test for #122
    specify do
      get :subscribe, :forum_id => forum.id, :id => topic.id
      flash[:alert].should == "The topic you are looking for could not be found."
    end
  end


  context "not signed in" do
    let(:forum) { create(:forum) }
    let(:user)  { create(:user, :login => 'other_forem_user', :email => "bob@boblaw.com", :custom_avatar_url => 'avatar.png') }
    let(:topic) { create(:approved_topic, :forum => forum, :user => user) }

    it "cannot delete topics" do
      delete :destroy, :forum_id => topic.forum.to_param, :topic_id => topic.to_param, :id => topic.to_param
      response.should redirect_to('/users/sign_in')
      flash.alert.should == "You must sign in first."
    end
  end

end
