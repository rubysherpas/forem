require 'spec_helper'

describe Forem::View do
  let!(:view) { FactoryGirl.create(:topic_view) }

  it "is valid with valid attributes" do
    view.should be_valid
  end

  describe "validations" do
    it "requires a viewable type" do
      view.viewable_type = nil
      view.should_not be_valid
    end

    it "requires a viewable id" do
      view.viewable_id = nil
      view.should_not be_valid
    end
  end

end
