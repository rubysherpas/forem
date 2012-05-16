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


  describe ".avatar_user_method" do
    it "can be set and retrieved" do
      Forem.avatar_user_method = "foo"
      Forem.avatar_user_method.should eq("foo")
      
      Forem.avatar_user_method = nil
      Forem.avatar_user_method.should be_nil
    end
  end
   
  describe ".email_from_address" do
    it "can be set and retrieved" do
      Forem.email_from_address = "foo"
      Forem.email_from_address.should eq("foo")

      Forem.email_from_address = nil
      Forem.email_from_address.should be_nil
    end
  end
end
