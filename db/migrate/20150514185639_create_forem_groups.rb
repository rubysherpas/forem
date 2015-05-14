# This migration comes from forem (originally 20120222155549)
class CreateForemGroups < ActiveRecord::Migration
  def change
    create_table :forem_groups do |t|
      t.string :name
      
      t.index :name
    end
  end
end
