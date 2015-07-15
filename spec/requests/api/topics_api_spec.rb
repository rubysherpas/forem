require 'spec_helper'

describe 'Topics API', type: :request do
  let(:forum) { create(:forum) }
  let(:user) { create(:user) }

  let(:authorized?) { true }

  before do
    Forem::Ability.any_instance.stub(:cannot?) { true } if !authorized?

    sign_in user
  end

  let(:json) { JSON.parse(response.body).with_indifferent_access }
  let(:data) { json[:data] }
  let(:errors) { json[:errors] }

  describe '#create' do
    let(:input_data) { {type: 'topics', attributes: attributes} }
    let(:attributes) { {subject: 'New topic'} }

    before { api :post, api_forum_topics_path(forum), data: input_data }

    it 'succeeds' do
      expect(response.response_code).to eq Rack::Utils::status_code(:created)
    end

    it 'provides a URL for the new topic' do
      expect(URI.parse(response.location).path).
        to eq api_forum_topic_path(forum, Forem::Topic.last)
    end

    it 'responds with JSON for the new topic' do
      expect(data[:type]).to eq 'topics'
      expect(data[:attributes][:subject]).to eq 'New topic'
      expect(data[:attributes][:views_count]).to eq 0
      expect(data[:attributes][:posts_count]).to eq 0
    end

    describe 'with valid data' do
      it 'succeeds' do
        expect(response.response_code).
          to eq Rack::Utils::status_code(:created)
      end

      it 'provides a URL for the new topic' do
        expect(URI.parse(response.location).path).
          to eq api_forum_topic_path(forum, Forem::Topic.last)
      end

      it 'responds with JSON for the new topic' do
        expect(data[:type]).to eq 'topics'
        expect(data[:attributes][:subject]).to eq 'New topic'
        expect(data[:attributes][:views_count]).to eq 0
        expect(data[:attributes][:posts_count]).to eq 0
      end
    end

    describe 'with no data' do
      let(:attributes) { {} }

      it 'fails' do
        expect(response.response_code).
          to eq Rack::Utils::status_code(:bad_request)
      end
    end

    describe 'with invalid data' do
      let(:attributes) { {nonexistent_attribute: 'New topic'} }

      it 'fails' do
        expect(response.response_code).
          to eq Rack::Utils::status_code(:bad_request)
      end

      it 'does not create a topic' do
        expect(Forem::Topic.count).to eq 0
      end

      it 'returns error objects' do
        expect(errors).not_to be_blank

        expect(errors.first[:title]).to eq "Subject can't be blank"
      end
    end

    describe 'with a client-generated ID' do
      let(:input_data) {
        {type: 'topics', id: 'generated-ID', attributes: attributes}
      }

      it 'is forbidden' do
        expect(response.response_code).
          to eq Rack::Utils::status_code(:forbidden)
      end
    end

    describe 'from an unauthenticated user' do
      let(:user) { nil }

      it 'is forbidden' do
        expect(response.response_code).
          to eq Rack::Utils::status_code(:forbidden)
      end

      it 'does not create a topic' do
        expect(Forem::Topic.count).to eq 0
      end
    end

    describe 'from an unauthorized user' do
      let(:authorized?) { false }

      it 'is forbidden' do
        expect(response.response_code).
          to eq Rack::Utils::status_code(:forbidden)
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

    it 'succeeds' do
      expect(response).to be_success
    end

    it 'responds with JSON for the new topic' do
      expect(data[:type]).to eq 'topics'
      expect(data[:attributes][:subject]).to eq 'Old topic'
      expect(data[:attributes][:user_id]).to eq topic.user_id
      expect(data[:attributes][:views_count]).to eq 2 # including initial post
      expect(data[:attributes][:posts_count]).to eq 1
      created_at = Time.zone.parse(data[:attributes][:created_at])
      expect(created_at).to be_within(0.05).of(topic.created_at)
    end

    let(:related_posts) { data[:relationships][:posts] }
    let(:related_post) { related_posts[:data].first }
    let(:included_posts) { included_objects_of_type('posts') }
    let(:included_post) { included_posts.first }

    it 'references related posts' do
      expect(related_posts[:data].length).to eq 1

      expect(related_post[:type]).to eq 'posts'
      expect(related_post[:id]).to eq post.id
    end
    
    it 'includes post data' do
      expect(included_posts.length).to eq 1

      expect(included_post[:id]).to eq post.id
      expect(included_post[:attributes][:text]).to eq post.text
      expect(included_post[:attributes][:user_id]).to eq post.user_id
      created_at = Time.zone.parse(included_post[:attributes][:created_at])
      expect(created_at).to be_within(0.05).of(post.created_at)
    end
    
    describe 'with an invalid ID' do
      let(:topic) { build(:topic, id: 0) }

      it 'is not found' do
        expect(response.response_code).
          to eq Rack::Utils::status_code(:not_found)
      end
    end

    describe 'from an unauthenticated user' do
      let(:user) { nil }

      it 'succeeds' do
        expect(response).to be_success
      end
    end

    describe 'from an unauthorized user' do
      let(:authorized?) { false }

      it 'is forbidden' do
        expect(response.response_code).
          to eq Rack::Utils::status_code(:forbidden)
      end
    end
  end
end
