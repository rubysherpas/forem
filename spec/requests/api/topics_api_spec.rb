require 'spec_helper'
require 'shared_examples/api_examples'

describe 'Topics API', type: :request do
  let(:data_type) { 'topics' }

  let(:forum) { create(:forum) }
  let(:user) { create(:user) }

  let(:authorized?) { true }

  before do
    allow_any_instance_of(Forem::Ability).
      to receive(:cannot?).and_return(!authorized?)

    sign_in user
  end

  describe '#create' do
    let(:input_data) { {type: 'topics', attributes: attributes} }
    let(:attributes) { {subject: 'New topic'} }
    let(:invalid_attributes) { {nonexistent_attribute: 'New topic'} }
    let(:invalid_attributes_message) { "Subject can't be blank" }
    let(:new_resource_url) { api_forum_topic_path(forum, Forem::Topic.last) }

    before { api :post, api_forum_topics_path(forum), data: input_data }

    it_behaves_like 'an API create request'

    describe 'with valid data' do
      it 'responds with JSON for the new topic' do
        expect(data[:type]).to eq data_type
        expect(data[:attributes][:subject]).to eq 'New topic'
        expect(data[:attributes][:slug]).to eq 'new-topic'
        expect(data[:attributes][:views_count]).to eq 0
        expect(data[:attributes][:posts_count]).to eq 0
      end
    end
  end

  describe '#show' do
    let(:topic) {
      create(:approved_topic, forum: forum, subject: 'Old topic',
        posts_attributes: [{text: 'Post text'}]
      )
    }
    let(:post) { topic.posts.first }

    before do
      topic.register_view_by(user) if topic.persisted?

      api :get, api_forum_topic_path(forum.id, topic.id)
    end

    it_behaves_like 'an API show request'

    it 'responds with JSON for the topic' do
      expect(data[:type]).to eq data_type
      expect(data[:attributes][:subject]).to eq 'Old topic'
      expect(data[:attributes][:slug]).to eq 'old-topic'
      expect(data[:attributes][:views_count]).to eq 2 # including initial post
      expect(data[:attributes][:posts_count]).to eq 1
      created_at = Time.zone.parse(data[:attributes][:created_at])
      expect(created_at).to be_within(0.05).of(topic.created_at)
    end

    let(:included_posts) { included_objects_of_type('posts') }
    let(:included_post) { included_posts.first }

    it 'references related posts' do
      expect(data).to reference_many(:posts, ['posts', post.id])
    end

    it 'references the related forum' do
      expect(data).to reference_one(:forum, ['forums', forum.id])
    end

    it 'references the related user' do
      expect(data).to reference_one(:user, ['users', topic.user_id])
    end

    it 'includes post data' do
      expect(included_posts.length).to eq 1

      expect(included_post[:id]).to eq post.id
      expect(included_post[:attributes][:text]).to eq post.text
      expect(included_post[:relationships][:user][:data][:id]).to eq post.user_id
      created_at = Time.zone.parse(included_post[:attributes][:created_at])
      expect(created_at).to be_within(0.05).of(post.created_at)
    end
    
    describe 'with an invalid ID' do
      let(:topic) { build(:topic, id: 0) }

      it 'is not found' do
        expect(response).to be_not_found
      end
    end
  end
end
