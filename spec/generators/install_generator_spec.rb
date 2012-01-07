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

  def backup_file(file)
    FileUtils.cp(file, file + ".bak")
  end

  def restore_file(file)
    FileUtils.mv(file + ".bak", file)
  end

  def cleanup!
    Dir.chdir(Rails.root) do
      FileUtils.rm_rf("db/migrate")

      FileUtils.rm("config/initializers/forem.rb")
      File.open("config/initializers/forem.rb", "w+") do |f|
        f.write "Forem.user_class = User"
      end
    end

    backup_or_restore = example.metadata[:run] ? "restore" : "backup"
    backup_or_restore = "#{backup_or_restore}_file"
    ["#{Rails.root}/app/controllers/application_controller.rb",
     "#{Rails.root}/config/routes.rb"].each do |file|
      send(backup_or_restore, file)
    end
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

    # Ensure forem admin migration has been created
    forem_admin_migration = File.readlines(migrations.last)
    forem_admin_migration[3].strip.should == "add_column :users, :forem_admin, :boolean, :default => false"

    # Ensure initializer has been created
    forem_initializer = File.readlines("#{Rails.root}/config/initializers/forem.rb")
    forem_initializer[0].strip.should == "Forem.user_class = User"

    # Ensure forem_user is added to ApplicationController
    application_controller = File.read("#{Rails.root}/app/controllers/application_controller.rb")
    expected_forem_user_method = %Q{def forem_user
    current_user
  end
  helper_method :forem_user}
    application_controller.should include(expected_forem_user_method)
  end

end
