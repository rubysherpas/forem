require 'spec_helper'

describe Forem::Forum do
  before(:each) do
    @attr = {
      :title => "A forum", 
      :description => "My sweet forum of goodness"
    }
    @forum = Forem::Forum.create!(@attr)
  end
  
  it "is valid with valid attributes" do
    @forum.should be_valid
  end
  
  describe "validations" do
    it "requires a title" do
      @forum.title = nil
      @forum.should_not be_valid
    end

    it "requires a description" do
      @forum.description = nil
      @forum.should_not be_valid
    end
  end
end
