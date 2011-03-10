module Forem
  class Engine < Rails::Engine
    # isolate_namespace Forem
  end
end

ENGINE_ROOT = Pathname.new(File.expand_path(File.dirname(__FILE__) + "/../.."))

require 'simple_form'

# Fixes this error:
# Encoding::CompatibilityError:
#        incompatible encoding regexp match (UTF-8 regexp with ASCII-8BIT string)
# Which happens when running integration specs containing a form
require 'rack/utils_monkey_patch'