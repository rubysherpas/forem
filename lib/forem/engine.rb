module Forem
  class Engine < Rails::Engine
    isolate_namespace Forem
  end
end

I18n.load_path << File.expand_path("config/locales/en.yml", File.dirname(__FILE__) + "../../..")