require 'spec_helper'

describe 'Forums API', type: :request do
  let(:forum) { create(:forum) }
  let!(:topic) { create(:approved_topic, forum: forum) }
  let!(:post) { create(:approved_post, topic: topic) }

  before do
    topic.register_view_by(post.user)
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

    let(:related_topics) { data[:relationships][:topics] }
    let(:related_topic) { related_topics[:data].first }
    let(:included_topics) { included_objects_of_type('topics') }
    let(:included_topic) { included_topics.first }

    it 'describes topic relationships' do
      expect(related_topics[:data].length).to eq 1

      expect(related_topic[:type]).to eq 'topics'
      expect(related_topic[:id]).to eq topic.id
    end

    it 'includes topic data' do
      expect(included_topics.length).to eq 1

      expect(included_topic[:id]).to eq topic.id
      expect(included_topic[:attributes][:subject]).to eq topic.subject
      expect(included_topic[:attributes][:posts_count]).to eq 2
      expect(included_topic[:attributes][:views_count]).to eq 1
    end

    let(:related_last_post) { related_topic[:relationships][:last_post][:data] }
    let(:included_posts) { included_objects_of_type('posts') }
    let(:included_post) { included_posts.last }

    it 'references the last post' do
      expect(related_last_post[:type]).to eq 'posts'
      expect(related_last_post[:id]).to eq post.id
    end

    it 'includes the last post' do
      expect(included_posts.length).to eq 1

      expect(included_post[:id]).to eq post.id
      created_at = Time.zone.parse(included_post[:attributes][:created_at])
      expect(created_at).to be_within(0.05).of(post.created_at)
    end
  end
end
