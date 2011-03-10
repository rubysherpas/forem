require 'pathname'
require 'fileutils'
namespace :forem do
  task :install do
    timestamp = Time.now.strftime("%Y%m%d%I%m%S")
    existing_migrations = Dir[Rails.root + "db/migrate/*"]
    Dir[File.dirname(__FILE__) + "/../../db/migrate/*.rb"].each do |file|
      migration_name = /\d+_(.*?)\.rb/.match(File.basename(file))[1]
      if existing_migrations.grep(migration_name)
        puts "Migration with name #{migration_name} already exists. Not copying."
      else
        timestamp += 1
        FileUtils.cp(File.expand_path(file), Rails.root + "db/migrate/#{timestamp}_#{migration_name}.rb")
      end
    end
  end
end

# module Rails
#   def self.root
#     Pathname.new(File.dirname(__FILE__) + "/../../")
#   end
# end
