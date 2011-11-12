module Forem
  class CategoriesController < ApplicationController
    def show
      @category = Category.find(params[:id])
    end
  end
end
