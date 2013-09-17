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
  s.add_development_dependency 'rspec-rails', '~> 2.13.0'
  s.add_development_dependency 'capybara', '2.1.0'  # higher requires Ruby 1.9
  s.add_development_dependency 'rails', '4.0.0'
  s.add_development_dependency 'jquery-rails'
  s.add_development_dependency 'protected_attributes'  
  s.add_development_dependency 'factory_girl_rails', '~> 3.6.0'
  s.add_development_dependency 'database_cleaner', '~> 1.0.0'
  s.add_development_dependency 'devise', '3.0.0'
  s.add_development_dependency 'kaminari', '~> 0.14.1'
  s.add_development_dependency 'timecop', '~> 0.6.1'

  s.add_dependency 'rails', '~> 4.0.0'
  s.add_dependency 'simple_form', '~> 3.0.0.rc'

  s.add_dependency 'workflow', '0.8.0'
  s.add_dependency 'gemoji', '= 1.1.2'
  s.add_dependency 'decorators', '~> 1.0.2'
  s.add_dependency 'select2-rails', '3.4.3'
end
