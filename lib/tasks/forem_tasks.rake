# desc "Explaining what the task does"
# task :forem do
#   # Task goes here
# end
#

task :environment do
  require './spec/dummy/config/environment'
end

task :routes => :environment do
  puts Forem::Engine.routes.routes
end
