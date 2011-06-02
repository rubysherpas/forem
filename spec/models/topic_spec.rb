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
      @topic1 = Factory(:topic)
      @topic2 = Factory(:topic)
    end

    it "should show pinned topics up top" do
      Forem::Topic.by_pinned.first.should == @topic1
      @topic2.pin!
      Forem::Topic.by_pinned.first.should == @topic2
    end
  end
end
