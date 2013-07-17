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

  context 'signed in' do
    let(:forum) { create(:forum) }
    let(:user)  { create(:user) }
    let(:topic) { create(:approved_topic, :forum => forum, :user => user) }

    context 'reply to topic' do
      context 'with permissions to read forum' do
        before do
          sign_in(user)
          controller.current_user.stub :can_read_forem_forum? => true
        end

        it 'can reply to topic' do
          post :create, :topic_id => topic.to_param, :post => { 'text' => 'non-sneaky reply' }
          flash[:notice].should == "Your reply has been posted."
        end
      end

      context 'without permissions to read forum' do
        before do
          sign_in(user)
          # remove user forum read permission
          controller.current_user.stub :can_read_forem_forum? => false
        end

        it 'cannot reply to topic' do
          post :create, :topic_id => topic.to_param, :post => { 'text' => 'sneaky reply' }
          flash[:alert].should == 'You are not allowed to do that.'
        end
      end
    end
  end
end
