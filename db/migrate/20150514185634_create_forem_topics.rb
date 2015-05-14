class CreateForemTopics < ActiveRecord::Migration
  def up
    create_table :forem_topics do |t|
      t.integer  :forum_id
      t.integer  :user_id
      t.string   :subject
      t.timestamps

      t.boolean  :locked, :null => false, :default => false # ?
      t.boolean  :pinned, :default => false, :nullable => false # ?
      t.boolean  :hidden, :default => false # ?
      t.datetime :last_post_at
      t.string   :state, :default => "pending_review"
      t.integer  :views_count, :default=>0 # ?
      t.string   :slug
      t.index    :forum_id
      t.index    :user_id
      t.index    :state
      t.index    :slug, :unique => true
    end
  end

  def down
    drop_table :forem_topics
  end
end