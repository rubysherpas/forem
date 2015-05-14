# This migration comes from forem (originally 20110214221555)
class CreateForemForums < ActiveRecord::Migration
  def up
    create_table :forem_forums do |t|
      t.string :name
      t.text :description

      t.integer :category_id
      t.integer :views_count, :default=>0
      t.string :slug
      t.integer :position, :default => 0

      t.index :slug, :unique => true
    end
  end

  def down
    drop_table :forem_forums
  end
end