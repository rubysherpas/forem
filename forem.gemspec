require File.expand_path('../lib/forem/version', __FILE__)
# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "forem"
  s.authors = ['Ryan Bigg', 'Philip Arndt']
  s.summary = "The best Rails 3 forum engine in the world."
  s.description = "The best Rails 3 forum engine in the world."
  s.files = `git ls-files`.split("\n")
  s.version = ::Forem.version

  s.add_development_dependency "launchy"
  s.add_development_dependency "rspec-rails", "~> 2.6"
  s.add_development_dependency "capybara"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "database_cleaner"
  s.add_dependency "simple_form"
  s.add_dependency "kaminari"
  s.add_dependency "rdiscount"
  s.add_dependency "gravatar_image_tag"
end
