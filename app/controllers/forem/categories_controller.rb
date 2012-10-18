module Forem
  class CategoriesController < Forem::ApplicationController
    load_and_authorize_resource
    before_filter :authenticate_forem_user
  end
end
