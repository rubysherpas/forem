require 'spec_helper'

describe Forem::PostsController do
  let!(:forum) { create(:forum) }
  let!(:user)  { create(:user) }
  let!(:topic) { create(:approved_topic, :forum => forum, :user => user) }

  context "not signed in" do
    let(:first_post) { topic.posts.first }

    it "cannot delete posts" do
      delete :destroy, :topic_id => topic.to_param, :id => first_post.to_param
      response.should redirect_to('/users/sign_in')
      flash.alert.should == "You must sign in first."
    end
  end

  context "signed in" do
    context "as an unapproved user" do
      before do
        user.update_column(:forem_state, "pending_review")
        controller.stub :forem_user => user
      end

      it "sends moderation emails" do
        Forem::ModerationQueueMailer.should_receive(:new_post).and_return(double('Mailer', :deliver => nil))
        post :create, :post => { :text => "This is a brand new post."}, :topic_id => topic.id
      end
    end

    context "as an approved user" do
      before do
        controller.stub :forem_user => user
      end

      it "does not send moderation emails" do
        Forem::ModerationQueueMailer.should_not_receive(:new_post)
        post :create, :post => { :text => "This is a brand new post."}, :topic_id => topic.id
      end
    end
  end
end
