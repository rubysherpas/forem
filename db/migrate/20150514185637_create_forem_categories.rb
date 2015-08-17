class CreateForemCategories < ActiveRecord::Migration
  def change
    create_table :forem_categories do |t|
      t.string :name, :null => false
      t.timestamps :null => false

      t.string :slug
      t.integer :position, :default => 0

      t.index :slug, :unique => true
    end

    Forem::Category.reset_column_information
    Forem::Category.find_each {|t| t.save! }
  end
end
