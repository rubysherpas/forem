require 'spec_helper'
require 'generators/forem/install_generator'

describe Forem::Generators::InstallGenerator do
  before { cleanup! }
  after { cleanup! }

  # So we can know whether to backup or restore in cleanup!
  # Wish RSpec had a setting for this already
  before { flag_example! }
  def flag_example!
    RSpec.current_example.metadata[:run] = true
  end

  def migrations
    Dir["#{Rails.root}/db/migrate/*.rb"].sort
  end

  it "copies over the migrations" do
    expect(migrations).to be_empty
    silence_stream(STDOUT) do
      described_class.start(["--user-class=User", "--no-migrate", "--current-user-helper=current_user"], :destination => Rails.root)
    end

    # Ensure forem migrations have been copied over
    expect(migrations).not_to be_empty

    # Ensure initializer has been created
    forem_initializer = File.readlines("#{Rails.root}/config/initializers/forem.rb")
    expect(forem_initializer[0].strip).to eq(%q{Forem.user_class = "User"})

    # Ensure forem_user is added to ApplicationController
    application_controller = File.read("#{Rails.root}/app/controllers/application_controller.rb")
    expected_forem_user_method = %Q{def forem_user
    current_user
  end
  helper_method :forem_user}
    expect(application_controller).to include(expected_forem_user_method)
  end

  it "seeds the database" do
    expect(Forem::Forum.count).to eq(0)
    expect(Forem::Topic.count).to eq(0)

    FactoryGirl.create(:user)
    FactoryGirl.create(:category)
    Forem::Engine.load_seed

    expect(Forem::Forum.count).to eq(1)
    expect(Forem::Topic.count).to eq(1)
  end

  it "seeds the database if a user exists already but Forem.user_class hasn't been set" do
    # This test recreates #495.
    expect(Forem::Forum.count).to eq(0)
    expect(Forem::Topic.count).to eq(0)

    # Pretend the user_class hasn't been decorated yet.
    # This reproduces the problem where the decorator is loaded
    # before the user class is set, and therefore the user class
    # can't be decorated in time.
    Object.send :remove_const, :User
    load "#{Rails.root}/app/models/user.rb"

    # Generate a user so the Forem seed can run fully.
    FactoryGirl.create(:user)
    Forem::Engine.load_seed

    expect(Forem::Forum.count).to eq(1)
    expect(Forem::Topic.count).to eq(1)
  end
end
