module Forem
  class CategoriesController < Forem::ApplicationController
    before_filter :find_category, :only => :show

    helper 'forem/forums'
    load_and_authorize_resource :class => 'Forem::Category'

    private

    def find_category
      @category = Forem::Category.includes(:forums => :category).find(params[:id])
    end
  end
end
