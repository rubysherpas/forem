require 'spec_helper'

describe "required configuration options must be set" do
  required_options = [:user_class]
  required_options.each do |option|
    it "requires #{option} is set" do
      Forem.send("#{option}=", nil)
      call_to_method = lambda { Forem.send("#{option}") }
      call_to_method.should raise_error(Forem::ConfigurationNotFound)

      Forem.send("#{option}=", "not nil")
      call_to_method.should_not raise_error
    end
  end
end

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
