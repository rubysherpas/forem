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

  it "is scoped by default" do
    # gsub replaces non-standard quotes (MySQL) with standard ones
    Forem::Category.all.to_sql.gsub(/`/, '"').should =~ /ORDER BY \"forem_categories\".\"position\" ASC/
  end

end
