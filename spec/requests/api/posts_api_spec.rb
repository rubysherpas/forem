require 'spec_helper'

describe 'Posts API', type: :request do
  let(:forum) { create(:forum) }
  let(:topic) { create(:topic, forum: forum) }
  let(:user) { create(:user) }

  let(:authorized?) { true }

  before do
    Forem::Ability.any_instance.stub(:cannot?) { !authorized? }

    sign_in user
  end

  let(:json) { JSON.parse(response.body).with_indifferent_access }
  let(:data) { json[:data] }
  let(:errors) { json[:errors] }

  describe '#create' do
    let(:input_data) { {type: 'posts', attributes: attributes} }
    let(:attributes) { {text: 'This is a post.'} }

    before do
      api :post, api_forum_topic_posts_path(forum, topic), data: input_data
    end

    describe 'with valid data' do
      it 'succeeds' do
        expect(response.response_code).to eq Rack::Utils::status_code(:created)
      end

      it 'provides a URL for the new post' do
        expect(URI.parse(response.location).path).
          to eq api_forum_topic_post_path(forum, topic, Forem::Post.last)
      end

      it 'responds with JSON for the new post' do
        expect(data[:type]).to eq 'posts'
        expect(data[:attributes][:text]).to eq 'This is a post.'
        expect(data[:attributes][:user_id]).to eq user.id
      end

      let(:related_topic) { data[:relationships][:topic][:data] }

      it 'references the topic' do
        expect(related_topic[:type]).to eq 'topics'
        expect(related_topic[:id]).to eq topic.id
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
      let(:attributes) { {nonexistent_attribute: 'Bad data'} }

      it 'fails' do
        expect(response.response_code).
          to eq Rack::Utils::status_code(:bad_request)
      end

      it 'returns error objects' do
        expect(errors).not_to be_blank

        expect(errors.first[:title]).to eq "Text can't be blank"
      end
    end

    describe 'with a client-generated ID' do
      let(:input_data) {
        {type: 'posts', id: 'generated-ID', attributes: attributes}
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
    end

    describe 'from an unauthorized user' do
      let(:authorized?) { false }

      it 'is forbidden' do
        expect(response.response_code).
          to eq Rack::Utils::status_code(:forbidden)
      end
    end
  end

  describe '#update' do
    let(:input_data) { {type: 'posts', attributes: attributes} }
    let(:attributes) { {text: 'This is still another post.'} }
    let(:post) { topic.posts.create(user: user, text: 'This is another post.') }

    before do
      api :patch, api_forum_topic_post_path(forum, topic, post), data: input_data
    end

    describe 'with valid data' do
      it 'succeeds' do
        expect(response.response_code).to eq Rack::Utils::status_code(:ok)
      end

      it 'responds with JSON for the post' do
        expect(data[:type]).to eq 'posts'
        expect(data[:attributes][:text]).to eq 'This is still another post.'
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
      let(:attributes) { {text: ''} }

      it 'fails' do
        expect(response.response_code).
          to eq Rack::Utils::status_code(:bad_request)
      end

      it 'returns error objects' do
        expect(errors).not_to be_blank

        expect(errors.first[:title]).to eq "Text can't be blank"
      end
    end

    describe 'with an updated ID' do
      let(:input_data) {
        {type: 'posts', id: post.id + 1, attributes: attributes}
      }

      it 'fails' do
        expect(response.response_code).
          to eq Rack::Utils::status_code(:conflict)
      end
    end

    describe 'from an unauthenticated user' do
      let(:user) { nil }

      it 'is forbidden' do
        expect(response.response_code).
          to eq Rack::Utils::status_code(:forbidden)
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
