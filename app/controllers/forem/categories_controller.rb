module Forem
  class CategoriesController < ::Forem::ApplicationController
    load_and_authorize_resource :find_by => :find_by_slug!

    def show
      @category = Category.find_by_slug!(params[:id])
    end
  end
end
