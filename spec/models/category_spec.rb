require 'spec_helper'

describe Forem::Category do
  let!(:category) { FactoryGirl.create(:category) }

  it "is valid with valid attributes" do
    expect(category).to be_valid
  end

  describe "validations" do
    it "requires a name" do
      category.name = nil
      expect(category).not_to be_valid
    end
  end

  it "by_position scope orders by position asc" do
    # gsub replaces non-standard quotes (MySQL) with standard ones
    expect(Forem::Category.by_position.to_sql.gsub(/`/, '"')).to match(/ORDER BY \"forem_categories\".\"position\" ASC/)
  end

end
