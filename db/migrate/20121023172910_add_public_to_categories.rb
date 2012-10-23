class AddPublicToCategories < ActiveRecord::Migration
  def change
    add_column :forem_categories, :public, :boolean, :default => false unless column_exists?(:forem_categories, :public)
  end
end
