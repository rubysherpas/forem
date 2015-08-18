require 'spec_helper'
require 'shared_examples/api_examples'

describe 'Forums API', type: :request do
  let(:data_type) { 'forums' }

  let(:user) { create(:user) }

  let(:authorized?) { true }

  before do
    Forem::Ability.any_instance.stub(:cannot?) { !authorized? }

    sign_in user
  end

  describe '#show' do
    let(:forum) { create(:forum) }
    let!(:topic) { create(:approved_topic, forum: forum) }
    let!(:post) { create(:approved_post, topic: topic) }

    before do
      topic.register_view_by(post.user)

      api :get, api_forum_path(forum)
    end

    it_behaves_like 'an API show request'

    it 'represents the forum' do
      expect(data[:type]).to eq data_type
      expect(data[:id]).to eq forum.id
      expect(data[:attributes][:title]).to eq forum.title
      expect(data[:attributes][:slug]).to eq forum.slug
    end

    let(:related_topics) { data[:relationships][:topics] }
    let(:related_topic) { related_topics[:data].first }
    let(:included_topics) { included_objects_of_type('topics') }
    let(:included_topic) { included_topics.first }

    it 'describes topic relationships' do
      expect(data).to reference_many(:topics, ['topics', topic.id])
    end

    it 'includes topic data' do
      expect(included_topics.length).to eq 1

      expect(included_topic[:id]).to eq topic.id
      expect(included_topic[:attributes][:subject]).to eq topic.subject
      expect(included_topic[:attributes][:slug]).to eq topic.slug
      expect(included_topic[:attributes][:posts_count]).to eq 2
      expect(included_topic[:attributes][:views_count]).to eq 1
    end

    let(:included_posts) { included_objects_of_type('posts') }
    let(:included_post) { included_posts.last }

    it 'references the last post' do
      expect(related_topic).to reference_one(:last_post, ['posts', post.id])
    end

    it 'includes the last post' do
      expect(included_posts.length).to eq 1

      expect(included_post[:id]).to eq post.id
      created_at = Time.zone.parse(included_post[:attributes][:created_at])
      expect(created_at).to be_within(0.05).of(post.created_at)
    end
  end
end
