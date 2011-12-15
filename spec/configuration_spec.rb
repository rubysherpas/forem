require 'spec_helper'

describe Forem do
  describe ".default_gravatar" do
    it "can be set and retrieved" do
      Forem.default_gravatar = "foo"
      Forem.default_gravatar.should eq("foo")

      Forem.default_gravatar = nil
      Forem.default_gravatar.should be_nil
    end
  end

  describe ".default_gravatar_image" do
    it "can be set and retrieved" do
      Forem.default_gravatar_image = "foo"
      Forem.default_gravatar_image.should eq("foo")

      Forem.default_gravatar_image = nil
      Forem.default_gravatar_image.should be_nil
    end
  end
end
