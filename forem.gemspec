# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "forem"
  s.summary = "The best Rails 3 forum engine in the world."
  s.description = "The best Rails 3 forum engine in the world."
  s.files = `git ls-files`.split("\n")
  s.version = "0.0.1"

  s.add_development_dependency "launchy"
  s.add_development_dependency "rspec-rails", "~> 2.5"
  s.add_development_dependency "capybara"
  s.add_development_dependency "sqlite3-ruby"
  # s.add_development_dependency "factory_girl"
  s.add_dependency "simple_form"
end
