class AddCategoriesToCategories < ActiveRecord::Migration
  def change
    add_column :forem_categories, :category_id, :integer unless column_exists?(:forem_categories, :category_id)
  end
end
