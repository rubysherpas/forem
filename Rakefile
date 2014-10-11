#!/usr/bin/env rake
begin
  require 'bundler/setup'
end

load 'lib/tasks/forem_tasks.rake'

$:.unshift File.join(File.dirname(__FILE__), 'spec','support')
load 'spec/lib/tasks/forem_spec_tasks.rake'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

Bundler::GemHelper.install_tasks

task :test_app => "forem:dummy_app"
