module Forem
  class CategoriesController < Forem::ApplicationController
    helper 'forem/forums'
    before_filter :find_category 
    load_and_authorize_resource :class => 'Forem::Category'

    private

    def find_category
      @category = Forem::Category.scoped_to(current_account).find(params[:id])
    end
  end
end
