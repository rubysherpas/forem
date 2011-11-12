require 'spec_helper'

# There is no User class within Forem; this is testing the dummy application's class
# More specifically, it is testing the methods provided by Forem::DefaultPermissions

describe User do
  subject { User.new }

  it "can read forums" do
    assert subject.can_read_forums?
  end

  it "can read a given forum" do
    assert subject.can_read_forum?(Forem::Forum.new)
  end
end
