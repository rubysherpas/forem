class AddOrderToCategories < ActiveRecord::Migration
  def change
    add_column :forem_categories, :order, :integer, :default => 0
  end
end
