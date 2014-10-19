class AddPositionToCategories < ActiveRecord::Migration
  def change
    add_column :forem_categories, :position, :integer, :default => 0
  end
end
