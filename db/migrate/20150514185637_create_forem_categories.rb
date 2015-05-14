# This migration comes from forem (originally 20111103210835)
class CreateForemCategories < ActiveRecord::Migration
  def change
    create_table :forem_categories do |t|
      t.string   :name, :null => false
      t.timestamps

      t.string   :slug
      t.integer  :position, :default => 0
      t.index    :slug, :unique => true
    end
  end
end
