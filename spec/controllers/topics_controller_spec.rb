require 'spec_helper'

describe Forem::TopicsController do
  context "attempting to subscribe to a hidden topic" do
    before do
      user = FactoryGirl.create(:user)
      sign_in(:user, user)

      forum = stub_model(Forem::Forum)

      controller.should_receive(:authorize!).and_return(true)
      Forem::Forum.should_receive(:find).and_return(forum)
      forum.stub_chain("topics.visible").and_return(visible_topics = stub)
      visible_topics.should_receive("approved_or_pending_review_for").with(user).and_return(approved_topics = stub)
      approved_topics.should_receive("find").and_raise(ActiveRecord::RecordNotFound)
    end

    # Regression test for #122
    specify do
      get :subscribe, :forum_id => 1, :id => 1
      flash[:alert].should == "The topic you are looking for could not be found."
    end
  end
  context "visiting on a non-canonical URL" do
    specify do
      topic = FactoryGirl.create(:topic, :approved)
      get :show, :forum_id => topic.forum.id, :id => topic.id
      response.code.to_i.should == 301
      response.body.should include forum_topic_path(topic.forum, topic)
    end
  end
end
