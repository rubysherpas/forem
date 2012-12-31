require File.expand_path('../lib/forem/version', __FILE__)
# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = 'forem'
  s.authors = ['Ryan Bigg', 'Philip Arndt', 'Josh Adams']
  s.summary = 'The best Rails 3 forum engine in the world.'
  s.description = 'The best Rails 3 forum engine in the world.'
  s.files = `git ls-files`.split("\n")
  s.version = ::Forem.version

  s.add_development_dependency 'launchy'
  s.add_development_dependency 'rspec-rails', '~> 2.6'
  s.add_development_dependency 'capybara', '1.1.3'
  s.add_development_dependency 'jquery-rails'
  s.add_development_dependency 'factory_girl_rails', '~> 1.7'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'devise'
  s.add_development_dependency 'kaminari'
  s.add_development_dependency 'timecop', '0.3.5'

  s.add_dependency 'rails', ['>= 3.1.10', '< 3.3'] | 0.upto(10).map{|i| "!= 3.2.#{i}"}
  s.add_dependency 'simple_form'
  s.add_dependency 'cancan', '1.6.8'
  s.add_dependency 'workflow', '0.8.0'
  s.add_dependency 'friendly_id', '~> 4.0', '>= 4.0.9'
  s.add_dependency 'gemoji', '= 1.1.2'
  s.add_dependency 'decorators', '~> 1.0.2'
end
