require 'spec_helper'
require 'subscribem/testing_support/factories/account_factory'

describe Forem::ModerationController do
  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  def create_forum(account, name)
    scoped_categories = Forem::Category.scoped_to(account)
    category = scoped_categories.create(:name => "A category")
    forum = Forem::Forum.scoped_to(account).new
    forum.name = name
    forum.description = "A forum"
    forum.category = category
    forum.tap(&:save!)
    forum
  end

  let!(:forum_a) do
    create_forum(account_a, "Account A's Forum")
  end

  let!(:forum_b) do
    create_forum(account_b, "Account B's Forum")
  end

  context "from Account A's subdomain" do
    before do
      @request.host = "#{account_a.subdomain}.example.com"
    end

    it "can access Account A's forum tools" do
      get :index, :forum_id => forum_a.id, :use_route => :forem
      response.status.should == 200
      page.current_url.should == "omg"
    end

    it "cannot access Account B's forum tools" do
      expect do
        get :index, :forum_id => forum_b.id, :use_route => :forem
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end