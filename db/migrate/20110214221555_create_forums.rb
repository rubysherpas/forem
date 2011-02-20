class CreateForums < ActiveRecord::Migration
  def up
    create_table :forums do |t|
      t.string :title
      t.text :description
    end

  end

  def down
    drop_table :forums
  end
end
