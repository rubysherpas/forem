require 'capybara/rails'
require 'capybara/dsl'

RSpec.configure do |c|
  c.include Capybara, :example_group => { :file_path => /\bspec\/integration\// }
end
