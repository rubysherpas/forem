require 'spec_helper'
require 'generators/forem/install_generator'

describe Forem::Generators::InstallGenerator do
  before { cleanup! }
  after { cleanup! }

  # So we can know whether to backup or restore in cleanup!
  # Wish RSpec had a setting for this already
  before { flag_example! }
  def flag_example!
    example.metadata[:run] = true
  end

  def migrations
    Dir["#{Rails.root}/db/migrate/*.rb"].sort
  end

  it "copies over the migrations" do
    migrations.should be_empty
    capture(:stdout) do
      described_class.start(["--user-class=User", "--no-migrate", "--current-user-helper=current_user"], :destination => Rails.root)
    end

    # Ensure forem migrations have been copied over
    migrations.should_not be_empty

    # Ensure initializer has been created
    forem_initializer = File.readlines("#{Rails.root}/config/initializers/forem.rb")
    forem_initializer[0].strip.should == "Forem.user_class = 'User'"

    # Ensure forem_user is added to ApplicationController
    application_controller = File.read("#{Rails.root}/app/controllers/application_controller.rb")
    expected_forem_user_method = %Q{def forem_user
    current_user
  end
  helper_method :forem_user}
    application_controller.should include(expected_forem_user_method)
  end

  it "seeds the database" do
    Forem::Forum.count.should == 0
    Forem::Topic.count.should == 0

    FactoryGirl.create(:user)
    FactoryGirl.create(:category)
    Forem::Engine.load_seed

    Forem::Forum.count.should == 1
    Forem::Topic.count.should == 1
  end

end
