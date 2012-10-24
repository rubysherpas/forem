class AddForemPublicToCategories < ActiveRecord::Migration
  def change
    add_column :forem_categories, :forem_public, :boolean, :default => false unless column_exists?(:forem_categories, :forem_public)
  end
end
