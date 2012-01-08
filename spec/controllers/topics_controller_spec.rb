require 'spec_helper'

describe Forem::TopicsController do
  let(:visible_topic) { Factory(:topic) }
  let(:hidden_topic) { Factory(:topic, :hidden => true) }

  before do
    sign_in(:user, Factory(:user))
  end

  # Regression test for #122
  it "cannot subscribe to a hidden topic" do
    get :subscribe, :forum_id => hidden_topic.forum_id, :id => hidden_topic.id
    flash[:alert].should == "The topic you are looking for could not be found."
  end

end
