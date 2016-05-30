require 'spec_helper'

describe 'Atom feed URL', type: :request do
  let(:forum) { create(:forum) }

  before { get forum_path(forum, format: :atom) }

  let(:feed) { Nokogiri.parse(response.body) }

  it 'should return Atom data' do
    expect(feed.root.name).to eq 'feed'
    expect(feed.root.namespace.href).to eq 'http://www.w3.org/2005/Atom'
  end
end