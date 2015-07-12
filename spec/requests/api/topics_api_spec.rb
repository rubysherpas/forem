require 'spec_helper'

describe 'Topics API', type: :request do
  let(:forum) { create(:forum) }
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#create' do
    let(:input_data) { {type: 'topics', attributes: attributes} }
    let(:attributes) { {subject: 'New topic'} }
    let(:authorized?) { true }

    before do
      Forem::Ability.any_instance.stub(:cannot?) { true } if !authorized?

      api :post, api_forum_topics_path(forum), data: input_data
    end

    let(:json) { JSON.parse(response.body).with_indifferent_access }
    let(:data) { json[:data] }

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

    let(:errors) { json[:errors] }

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
end
