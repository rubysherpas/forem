module Forem
  class CategoriesController < Forem::ApplicationController
    load_and_authorize_resource

    def show
      @category = Category.find(params[:id])
      if @category.slug != params[:id]
        redirect_to @category, status: :moved_permanently
      end
    end
  end
end
