namespace :forem do
  desc "Generates a dummy app for testing"
  task :dummy_app => [:setup_dummy_app, :migrate_dummy_app]

  task :setup_dummy_app do
    require 'rails'
    require 'forem'
    require File.expand_path('../../generators/forem/dummy/dummy_generator', __FILE__)

    Forem::DummyGenerator.start %w(--quiet)
  end

  task :migrate_dummy_app do
    ENV['RAILS_ENV'] = 'test'
    Dir.chdir(Forem::Engine.root + "spec/dummy") do
      system("bundle exec rake forem:install:migrations db:drop db:create db:migrate db:seed")
    end
  end
end
