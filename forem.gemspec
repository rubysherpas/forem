# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "forem"
  s.summary = "Insert Forem summary."
  s.description = "Insert Forem description."
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.version = "0.0.1"

  s.add_development_dependency "launchy"
  s.add_development_dependency "rspec-rails", "~> 2.5"
  s.add_development_dependency "capybara"
  s.add_development_dependency "sqlite3-ruby"
  s.add_dependency "simple_form"
end
