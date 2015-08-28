require 'spec_helper'

# There is no User class within Forem; this is testing the dummy application's class
# More specifically, it is testing the methods provided by Forem::DefaultPermissions

describe User do
  subject { User.new }

  describe Forem::DefaultPermissions do
    it "can read forums" do
      assert subject.can_read_forem_forums?
    end

    it "can read a given forum" do
      assert subject.can_read_forem_forum?(Forem::Forum.new)
    end
  end

  describe "Profile methods" do
    context "with custom methods" do
      describe "#forem_email" do
        it "responds to our own email method" do
          expect(subject).to receive :email
          subject.forem_email
        end
      end

      describe "#forem_name" do
        it "responds to our own name method" do
          expect(subject).to receive :login
          subject.forem_name
        end
      end
    end

    context "with defaults" do
      # Using a class without custom methods
      subject { Refunery::Yooser.new }

      before do
        @original_class_name = Forem.user_class
        Forem.user_class = "Refunery::Yooser"
        Forem.decorate_user_class!
      end

      after do
        Forem.user_class = @original_class_name.to_s
      end

      describe "#forem_email" do
        it "defaults with 'email'" do
          expect(subject).to respond_to :forem_email
          expect(subject).to receive(:email)
          subject.forem_email
        end
      end

      describe "#forem_name" do
        it "defaults with 'to_s'" do
          expect(subject).to respond_to :forem_name
          expect(subject).to receive :to_s
          subject.forem_name
        end
      end
    end
  end
end
