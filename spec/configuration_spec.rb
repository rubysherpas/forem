require 'spec_helper'

describe Forem do
  describe ".default_gravatar" do
    it "can be set and retrieved" do
      Forem.default_gravatar = "foo"
      expect(Forem.default_gravatar).to eq("foo")

      Forem.default_gravatar = nil
      expect(Forem.default_gravatar).to be_nil
    end
  end

  describe ".default_gravatar_image" do
    it "can be set and retrieved" do
      Forem.default_gravatar_image = "foo"
      expect(Forem.default_gravatar_image).to eq("foo")

      Forem.default_gravatar_image = nil
      expect(Forem.default_gravatar_image).to be_nil
    end
  end


  describe ".avatar_user_method" do
    it "can be set and retrieved" do
      Forem.avatar_user_method = "foo"
      expect(Forem.avatar_user_method).to eq("foo")

      Forem.avatar_user_method = nil
      expect(Forem.avatar_user_method).to be_nil
    end
  end

  describe ".email_from_address" do
    it "can be set and retrieved" do
      Forem.email_from_address = "foo"
      expect(Forem.email_from_address).to eq("foo")

      Forem.email_from_address = nil
      expect(Forem.email_from_address).to be_nil
    end
  end

  describe ".sign_in_path" do
    it "can be set and retrieved" do
      Forem.sign_in_path = "users/sign_in"
      expect(Forem.sign_in_path).to eq("users/sign_in")

      Forem.sign_in_path =  nil
      expect(Forem.sign_in_path).to be_nil
    end
  end
end
