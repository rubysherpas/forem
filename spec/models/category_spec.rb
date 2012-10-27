require 'spec_helper'

describe Forem::Category do
  let!(:category) { FactoryGirl.create(:category) }
  let!(:c1) { FactoryGirl.create(:category) }
  let!(:c2) { FactoryGirl.create(:category) }
  let!(:c3) { FactoryGirl.create(:category) }

  it "is valid with valid attributes" do
    category.should be_valid
  end
  
  describe 'creation' do
    it 'makes corresponding admin group' do
      Forem::Group.find_by_name(category.name + Forem::Group::ADMIN_POSTFIX).should_not be_nil
    end
    
    it 'makes corresponding category group' do
      Forem::Group.find_by_name(category.name).should_not be_nil
    end
  end

  describe "validations" do
    
    it 'is not recursive' do
      category.category_id = category.id
      category.should_not be_valid
    end
    
    it 'is not in a cycle' do
      c2.category_id = c1.id
      c2.save
      c3.category_id = c2.id
      
      c3.should_not be_valid
      #c3.errors.should be > 0
    end
    
    it "requires a name" do
      category.name = nil
      category.should_not be_valid
    end
  end

end
