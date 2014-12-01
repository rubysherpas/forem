require 'spec_helper'

describe Forem::Category do
  let!(:category) { FactoryGirl.create(:category) }

  it "is valid with valid attributes" do
    category.should be_valid
  end

  describe "validations" do
    it "requires a name" do
      category.name = nil
      category.should_not be_valid
    end
  end

  it "by_position scope orders by position asc" do
    # gsub replaces non-standard quotes (MySQL) with standard ones
    Forem::Category.by_position.to_sql.gsub(/`/, '"').should =~ /ORDER BY \"forem_categories\".\"position\" ASC/
  end

end
