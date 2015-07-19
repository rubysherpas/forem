require_dependency "forem/application_controller"

module Forem
  module Api
    module V1
      class ForumsController < Forem::ForumsController
        include JsonApiController
      end
    end
  end
end
