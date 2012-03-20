module Forem
  class CategoriesController < ::Forem::ApplicationController
    load_and_authorize_resource :find_by => :find_by_slug!

    def show
      @category = Category.find(Forem::Category.id_from_param(params[:id]))
    end
  end
end
