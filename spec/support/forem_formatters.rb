# MRI-specific C-extention tests
if RUBY_VERSION < "1.9" || RUBY_ENGINE == "ruby"
  require "forem/formatters/redcarpet"
else
  require "forem/formatters/kramdown"
end
