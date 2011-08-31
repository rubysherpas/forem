require 'refinery/generators'

module Refinery
  class ForemGenerator < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../../../../', __FILE__)
    engine_name "refinerycms-forem"

  end
end