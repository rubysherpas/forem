module Forem
  class CategoriesController < Forem::ApplicationController
    helper 'forem/forums'
    load_and_authorize_resource
    before_filter :ensure_canonical_url, :only => :show
  end
end
