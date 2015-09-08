require 'spec_helper'

describe Forem::View do
  let!(:view) { FactoryGirl.create(:topic_view) }

  it "is valid with valid attributes" do
    expect(view).to be_valid
  end

  describe "validations" do
    it "requires a viewable type" do
      view.viewable_type = nil
      expect(view).not_to be_valid
    end

    it "requires a viewable id" do
      view.viewable_id = nil
      expect(view).not_to be_valid
    end
  end

end
