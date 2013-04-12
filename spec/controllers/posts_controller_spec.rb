require 'spec_helper'

describe Forem::PostsController do
  context "not signed in" do
    let(:forum) { create(:forum) }
    let(:user)  { create(:user) }
    let(:topic) { create(:approved_topic, :forum => forum, :user => user) }
    let(:first_post) { topic.posts.first }

    it "cannot delete posts" do
      delete :destroy, :topic_id => topic.to_param, :id => first_post.to_param
      response.should redirect_to('/users/sign_in')
      flash.alert.should == "You must sign in first."
    end
  end
end
