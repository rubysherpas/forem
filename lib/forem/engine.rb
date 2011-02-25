module Forem
  class Engine < Rails::Engine
    isolate_namespace Forem
  end
end

require 'simple_form'

# Fixes this error:
# Encoding::CompatibilityError:
#        incompatible encoding regexp match (UTF-8 regexp with ASCII-8BIT string)
# Which happens when running integration specs containing a form
require 'rack/utils_monkey_patch'

# To load the translations, which *should* be automatically loaded
I18n.load_path << File.expand_path("config/locales/en.yml", File.dirname(__FILE__) + "../../..")