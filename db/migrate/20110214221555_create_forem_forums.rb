class CreateForemForums < ActiveRecord::Migration
  def self.up
    create_table :forem_forums do |t|
      t.string :title
      t.text :description
    end

  end

  def self.down
    drop_table :forem_forums
  end
end
