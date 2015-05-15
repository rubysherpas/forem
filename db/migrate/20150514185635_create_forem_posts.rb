class CreateForemPosts < ActiveRecord::Migration
  def change
    create_table :forem_posts do |t|
      t.integer :topic_id
      t.text :text
      t.integer :user_id
      t.timestamps :null => false

      t.integer :reply_to_id
      t.string :state, :default => 'pending_review'
      t.boolean :notified, :default => false

      t.index :topic_id
      t.index :user_id
      t.index :reply_to_id
      t.index :state
    end

    Forem::Post.update_all :state => "approved"
  end
end