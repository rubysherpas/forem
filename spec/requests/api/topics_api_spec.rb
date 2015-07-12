require 'spec_helper'

describe 'Topics API', type: :request do
  let(:forum) { create(:forum) }
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#create' do
    before do
      api :post, api_forum_topics_path(forum),
        data: {
          type: 'topics',
          attributes: {
            subject: 'New topic'
          }
        }
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
  end
end
