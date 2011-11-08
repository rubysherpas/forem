require 'spec_helper'

describe Forem::Category do
  before(:each) do
    @attr = {
      :name=> "Test Category",
    }
    @category = Forem::Category.create!(@attr)
  end

  it "is valid with valid attributes" do
    @category.should be_valid
  end

  describe "validations" do
    it "requires a name" do
      @category.name = nil
      @category.should_not be_valid
    end
  end

end
