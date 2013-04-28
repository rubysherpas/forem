module Forem
  module CategoriesHelper
    def category_title
      I18n.t('forem.category.page_title', :category => @category.name)
    end
  end
end
