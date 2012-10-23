module Forem
  class CategoriesController < Forem::ApplicationController
    helper 'forem/forums'
    load_and_authorize_resource
    before_filter :authenticate_forem_user
  end
end
