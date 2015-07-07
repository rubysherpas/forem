require 'spec_helper'

describe 'Forums API', type: :request do
  let(:forum) { create(:forum) }
  let!(:topic) { create(:topic, forum: forum) }

  def api(method, action, params = {})
    send method, action, params,
      Accept: 'application/vnd.forem+json; version=1'
  end

  describe '#show' do
    before { api :get, api_forum_path(forum) }

    let(:json) { JSON.parse(response.body).with_indifferent_access }
    let(:data) { json[:data] }

    it 'succeeds' do
      expect(response).to be_success
    end

    it 'represents the forum' do
      expect(data[:type]).to eq 'forums'
      expect(data[:id]).to eq forum.id
      expect(data[:attributes][:title]).to eq forum.title
      expect(data[:attributes][:slug]).to eq forum.slug
    end

    let(:related_topics) { json[:relationships][:topics] }
    let(:included_objects) { json[:included] }

    it 'describes topic relationships' do
      expect(related_topics[:data].length).to eq 1
      related_topic = related_topics[:data].first

      expect(related_topic[:type]).to eq 'topics'
      expect(related_topic[:id]).to eq topic.id
    end

    it 'includes topic data' do
      expect(included_objects.length).to eq 1
      included_topic = included_objects.first

      expect(included_topic[:type]).to eq 'topics'
      expect(included_topic[:id]).to eq topic.id
      expect(included_topic[:attributes][:subject]).to eq topic.subject
    end
  end
end
