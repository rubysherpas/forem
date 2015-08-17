class CreateForemForums < ActiveRecord::Migration
  def change
    create_table :forem_forums do |t|
      t.string :name
      t.text :description

      t.integer :category_id
      t.integer :views_count, :default=>0
      t.string :slug
      t.integer :position, :default => 0

      t.index :slug, :unique => true
    end

    if Forem::Forum.count > 0
      Forem::Forum.update_all :category_id => Forem::Category.first.id
    end
    Forem::Forum.find_each do |forum|
      forum.update_column(:views_count, forum.topics.sum(:views_count))
    end
    Forem::Forum.reset_column_information
    Forem::Forum.find_each {|t| t.save! }
  end
end
