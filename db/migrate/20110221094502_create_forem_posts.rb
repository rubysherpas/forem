class CreateForemPosts < ActiveRecord::Migration
  def change
    create_table :forem_posts do |t|
      t.integer :topic_id
      t.text :text
      t.integer :user_id

      t.timestamps :null => true
    end
  end
end
