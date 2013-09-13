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
    before do
      sign_in(user)
    end

    context 'reply to topic' do
      context 'with permissions to read forum' do
        before do
          controller.current_user.stub :can_read_forem_forum? => true
        end

        it 'can reply to topic' do
          post :create, :topic_id => topic.to_param, :post => { 'text' => 'non-sneaky reply' }
          flash[:notice].should == "Your reply has been posted."
        end
      end

      context 'without permissions to read forum' do
        before do
          # remove user forum read permission
          controller.current_user.stub :can_read_forem_forum? => false
        end

        it 'cannot reply to topic' do
          post :create, :topic_id => topic.to_param, :post => { 'text' => 'sneaky reply' }
          flash[:alert].should == 'You are not allowed to do that.'
        end
      end
    end
    
    context 'when attempting to destroy posts' do
      it 'can with permission' do
        delete :destroy, :topic_id => topic, :id => topic.posts.first
        flash[:notice].should == "Only post in topic deleted. Topic also deleted."
      end
      
      it 'cannot without permission' do
        # remove destroy permission
        controller.current_user.stub :can_destroy_forem_posts? => false
        
        delete :destroy, :topic_id => topic, :id => topic.posts.first
        flash[:alert].should == 'You are not allowed to do that.'
        response.should redirect_to(root_path)
      end
    end
  end
end
