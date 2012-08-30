module Forem
  class CategoriesController < Forem::ApplicationController
    load_and_authorize_resource
  end
end
