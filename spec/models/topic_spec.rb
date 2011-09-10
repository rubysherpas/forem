require 'spec_helper'

describe Forem::Topic do
  before(:each) do
    Forem::Topic.any_instance.stub(:set_first_post_user).and_return(true)
    @attr = {
      :subject => "A topic"
    }
    @topic = Forem::Topic.create!(@attr)
  end
  
  it "is valid with valid attributes" do
    @topic.should be_valid
  end
  
  describe "validations" do
    it "requires a subject" do
      @topic.subject = nil
      @topic.should_not be_valid
    end
  end
  
  describe "protected attributes" do
    it "cannot assign pinned" do
      topic = Forem::Topic.new(:pinned => true)
      topic.pinned.should be_false
    end
    
    it "cannot assign locked" do
      topic = Forem::Topic.new(:locked => true)
      topic.locked.should be_false
    end
  end

  describe "pinning" do
    before(:each) do
      Forem::Topic.delete_all
      @topic1 = FactoryGirl.create(:topic)
      @topic2 = FactoryGirl.create(:topic)
    end

    it "should show pinned topics up top" do
      Forem::Topic.by_pinned.first.should == @topic1
      @topic2.pin!
      Forem::Topic.by_pinned.first.should == @topic2
    end
  end

  describe ".by_most_recent_post" do
    before do
      Forem::Topic.delete_all
      @topic1 = Forem::Topic.create :subject => "POST"
      FactoryGirl.create(:post, :topic => @topic1, :created_at => 1.seconds.ago)
      @topic2 = Forem::Topic.create :subject => "POST"
      FactoryGirl.create(:post, :topic => @topic2, :created_at => 5.seconds.ago)
      @topic3 = Forem::Topic.create :subject => "POST"
      FactoryGirl.create(:post, :topic => @topic3, :created_at => 10.seconds.ago)
    end

    it "should show topics by most recent post" do
      Forem::Topic.by_most_recent_post.to_a.map(&:id).should == [@topic1.id, @topic2.id, @topic3.id]
    end
  end
end
