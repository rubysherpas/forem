require 'spec_helper'

describe 'Forums API', type: :request do
  let(:forum) { create(:forum) }

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
  end
end