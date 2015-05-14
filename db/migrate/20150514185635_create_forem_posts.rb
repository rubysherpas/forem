class CreateForemPosts < ActiveRecord::Migration
  def up
    create_table :forem_posts do |t|
      t.integer  :topic_id
      t.text     :text
      t.integer  :user_id
      t.integer  :reply_to_id
      t.timestamps

      t.string   :state, :default => 'pending_review' # ?
      t.boolean  :notified, :default => false # ?
      t.index    :topic_id
      t.index    :user_id
      t.index    :reply_to_id
      t.index    :state
    end
  end

  def down
  	drop_table :forem_posts
  end
end
