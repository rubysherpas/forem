require 'spec_helper'
require 'shared_examples/api_examples'

describe 'Posts API', type: :request do
  let(:data_type) { 'posts' }

  let(:forum) { create(:forum) }
  let(:topic) { create(:topic, forum: forum) }
  let(:user) { create(:user) }

  let(:authorized?) { true }

  before do
    Forem::Ability.any_instance.stub(:cannot?) { !authorized? }

    sign_in user
  end

  describe '#create' do
    let(:input_data) { {type: data_type, attributes: attributes} }
    let(:attributes) { {text: 'This is a post.'} }
    let(:invalid_attributes) { {nonexistent_attribute: 'Bad data'} }
    let(:invalid_attributes_message) { "Text can't be blank" }
    let(:new_resource_url) {
      api_forum_topic_post_path(forum, topic, Forem::Post.last)
    }

    before do
      api :post, api_forum_topic_posts_path(forum, topic), data: input_data
    end

    it_behaves_like 'an API create request'

    describe 'with valid data' do
      it 'responds with JSON for the new post' do
        expect(data[:type]).to eq data_type
        expect(data[:attributes][:text]).to eq 'This is a post.'
        expect(data[:attributes][:user_id]).to eq user.id
      end

      let(:related_topic) { data[:relationships][:topic][:data] }

      it 'references the topic' do
        expect(related_topic[:type]).to eq 'topics'
        expect(related_topic[:id]).to eq topic.id
      end
    end
  end

  describe '#update' do
    let(:input_data) { {type: data_type, attributes: attributes} }
    let(:attributes) { {text: 'This is still another post.'} }
    let(:invalid_attributes) { {text: ''} }
    let(:invalid_attributes_message) { "Text can't be blank" }

    let(:post) { topic.posts.create(user: user, text: 'This is another post.') }
    let(:model) { post }

    before do
      api :patch, api_forum_topic_post_path(forum, topic, post), data: input_data
    end

    it_behaves_like 'an API update request'

    describe 'with valid data' do
      it 'responds with JSON for the post' do
        expect(data[:type]).to eq data_type
        expect(data[:attributes][:text]).to eq 'This is still another post.'
      end
    end
  end
end
