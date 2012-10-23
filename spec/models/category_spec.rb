require 'spec_helper'

describe Forem::Category do
  let!(:category) { FactoryGirl.create(:category) }

  it "is valid with valid attributes" do
    category.should be_valid
  end
  
  describe 'creation' do
    it 'makes corresponding admin group' do
      Forem::Group.find_by_name(category.name + Forem::Group.ADMIN_POSTFIX).should_not be_nil
    end
    
    it 'makes corresponding category group' do
      Forem::Group.find_by_name(category.name).should_not be_nil
    end
  end

  describe "validations" do
    it "requires a name" do
      category.name = nil
      category.should_not be_valid
    end
  end

end
