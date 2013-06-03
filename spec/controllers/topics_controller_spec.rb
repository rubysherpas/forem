require 'spec_helper'

describe Forem::TopicsController do
  context "attempting to subscribe to a hidden topic" do
    before do
      user = FactoryGirl.create(:user)
      sign_in(user)

      forum = stub_model(Forem::Forum)

      controller.should_receive(:authorize!).and_return(true)
      Forem::Forum.should_receive(:find).and_return(forum)
      forum.stub_chain("topics.visible").and_return(visible_topics = stub)
      visible_topics.should_receive("approved_or_pending_review_for").with(user).and_return(approved_topics = stub)
      approved_topics.should_receive("find").and_raise(ActiveRecord::RecordNotFound)
    end

    # Regression test for #122
    specify do
      get :subscribe, :forum_id => 1, :id => 1
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

  context "moderation" do
    let!(:forum) { create(:forum) }
    let(:topic_attributes) {
      { :subject => "This is a brand new topic.", :posts_attributes => {"0" => {:text => "first!"}}}
    }
    before { controller.stub :forem_user => user }
    context "as an unapproved user" do
      let!(:user)  { create(:user, :forem_state => 'pending_review') }

      it "sends moderation emails" do
        controller.should_receive(:deliver_moderation_notification)
        post :create, :topic => topic_attributes, :forum_id => forum.id
      end
    end

    context "as an approved user" do
      let!(:user)  { create(:user, :forem_state => 'approved') }
      it "does not send moderation emails" do
        controller.should_not_receive(:deliver_moderation_notification)
        post :create, :topic => topic_attributes, :forum_id => forum.id
      end
    end
  end

end
