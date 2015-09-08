require 'spec_helper'

describe Forem::Admin::ForumsController do
  use_forem_routes
  let(:user) { FactoryGirl.create(:user, forem_admin: true) }

  before do
    allow(controller).to receive_messages current_user: user
  end

  it "forum_params permits all the necessary fields" do
    group = FactoryGirl.create(:group)
    category = FactoryGirl.create(:category)

    expect(Forem::Forum).to receive(:new).with({
      category_id: category.id.to_s,
      title: 'Forum title',
      description: 'Description for the forum',
      position: '1',
      moderator_ids: [group.id.to_s]
    }.with_indifferent_access).and_call_original

    post :create, forum: {
      category_id: category.id,
      title: 'Forum title',
      description: 'Description for the forum',
      position: 1,
      moderator_ids: [group.id]
    }
  end

end
