require 'spec_helper'

describe Forem::PostsController do
  use_forem_routes

  context "not signed in" do
    let(:forum) { create(:forum) }
    let(:user)  { create(:user) }
    let(:topic) { create(:approved_topic, :forum => forum, :user => user) }
    let(:first_post) { topic.posts.first }

    it "cannot delete posts" do
      delete :destroy, :forum_id => forum.to_param, :topic_id => topic.to_param, :id => first_post.to_param
      expect(response).to redirect_to('/users/sign_in')
      expect(flash.alert).to eq("You must sign in first.")
    end

    it "can be redirected to post on topic" do
      get :show, :forum_id => forum.to_param, :topic_id => topic.to_param, :id => first_post.to_param
      expect(response).to redirect_to("/forem/welcome-to-forem/topics/first-topic?page=1#post-#{first_post.id}")
    end
  end

  context 'signed in' do
    let(:forum) { create(:forum) }
    let(:user)  { create(:user) }
    let(:topic) { create(:approved_topic, :forum => forum, :user => user) }
    before do
      # simulate signed in user
      allow(controller).to receive_messages :current_user => user
    end

    context 'reply to topic' do
      context 'with permissions to read forum' do
        before do
          allow(controller.current_user).to receive_messages :can_read_forem_forum? => true
        end

        it 'can reply to topic' do
          post :create, 
            :forum_id => forum.to_param,
            :topic_id => topic.to_param,
            :post => { 'text' => 'non-sneaky reply' }
          expect(flash[:notice]).to eq("Your reply has been posted.")
        end
      end

      context 'without permissions to read forum' do
        before do
          # remove user forum read permission
          allow(controller.current_user).to receive_messages :can_read_forem_forum? => false
        end

        it 'cannot reply to topic' do
          post :create, :forum_id => forum.to_param, :topic_id => topic.to_param, :post => { 'text' => 'sneaky reply' }
          expect(flash[:alert]).to eq('You are not allowed to do that.')
        end
      end

      context 'without permissions to reply to topics' do
        before do
          allow(controller.current_user).to receive_messages :can_reply_to_forem_topic? => false
        end

        it "cannot access the new action" do
          get :new,
            :forum_id => forum.to_param,
            :topic_id => topic.to_param
          expect(flash[:alert]).to eq('You are not allowed to do that.')
          expect(response).to redirect_to('/forem/')
        end

        it "cannot access the create action" do
          post :create,
            :forum_id => forum.to_param,
            :topic_id => topic.to_param,
            :post => { :text => "Test" }
            expect(flash[:alert]).to eq('You are not allowed to do that.')
            expect(response).to redirect_to('/forem/')
        end
      end
    end

    context 'when attempting to edit posts' do
      context 'without permission' do
        before do
          allow(controller.current_user).to receive_messages :can_edit_forem_posts? => false
        end

        it "denies access" do
          get :edit,
            :forum_id => forum.to_param,
            :topic_id => topic.to_param,
            :id => 1
          expect(flash[:alert]).to eq('You are not allowed to do that.')
          expect(response).to redirect_to('/forem/')
        end
      end
    end

    context 'when attempting to destroy posts' do
      it 'can with permission' do
        delete :destroy, :forum_id => forum, :topic_id => topic, :id => topic.posts.first
        expect(flash[:notice]).to eq("Only post in topic deleted. Topic also deleted.")
      end

      it 'cannot without permission' do
        # remove destroy permission
        allow(controller.current_user).to receive_messages :can_destroy_forem_posts? => false

        delete :destroy, :forum_id => forum, :topic_id => topic, :id => topic.posts.first
        expect(flash[:alert]).to eq('You are not allowed to do that.')
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
