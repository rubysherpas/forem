# desc "Explaining what the task does"
# task :forem do
#   # Task goes here
# end
#

namespace :forem do
  task :environment do
    require './spec/dummy/config/environment'
  end

  task :routes => :environment do
    all_routes = Forem::Engine.routes.routes

    if ENV['CONTROLLER']
      all_routes = all_routes.select{ |route| route.defaults[:controller] == ENV['CONTROLLER'] }
    end

    routes = all_routes.collect do |route|

      reqs = route.requirements.dup
      reqs[:to] = route.app unless route.app.class.name.to_s =~ /^ActionDispatch::Routing/
      reqs = reqs.empty? ? "" : reqs.inspect

      {:name => route.name.to_s, :verb => route.verb.to_s, :path => route.path, :reqs => reqs}
    end

     # Skip the route if it's internal info route
    routes.reject! { |r| r[:path] =~ %r{/rails/info/properties|^/assets} }

    name_width = routes.map{ |r| r[:name].length }.max
    verb_width = routes.map{ |r| r[:verb].length }.max
    path_width = routes.map{ |r| r[:path].length }.max

    routes.each do |r|
      puts "#{r[:name].rjust(name_width)} #{r[:verb].ljust(verb_width)} #{r[:path].ljust(path_width)} #{r[:reqs]}"
    end
  end

  desc "Generates a dummy app for testing"
  task :dummy_app => [:setup_dummy_app, :migrate_dummy_app]

  task :setup_dummy_app do
    require 'rails'
    require 'forem'
    require File.expand_path('../../generators/forem/dummy/dummy_generator', __FILE__)

    Forem::DummyGenerator.start %w(--quiet)
  end

  task :migrate_dummy_app do
    task_params = [%Q{ bundle exec rake -f spec/dummy/Rakefile forem:install:migrations }]
    task_params << %Q{ db:drop db:create db:migrate db:seed db:test:prepare }

    system task_params.join(' ')
  end

  desc "Destroy dummy app"
  task :destroy_dummy_app do
    FileUtils.rm_rf "spec/dummy" if File.exists?("spec/dummy")
  end
end
