class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :topic_id
      t.text :text
      t.integer :user_id

      t.timestamps
    end
  end
end
