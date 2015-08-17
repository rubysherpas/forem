class CreateForemTopics < ActiveRecord::Migration
  def change
    create_table :forem_topics do |t|
      t.integer :forum_id
      t.integer :user_id
      t.string :subject
      t.timestamps :null => false

      t.boolean :locked, :null => false, :default => false
      t.boolean :pinned, :default => false, :nullable => false
      t.boolean :hidden, :default => false
      t.string :state, :default => 'pending_review'
      t.datetime :last_post_at
      t.integer :views_count, :default=>0
      t.string :slug

      t.index :forum_id
      t.index :user_id
      t.index :state
      t.index :slug, :unique => true
    end

    Forem::Topic.reset_column_information
    Forem::Topic.includes(:posts).find_each do |t|
      post = t.posts.last
      t.update_attribute(:last_post_at, post.updated_at)
    end
    Forem::Topic.update_all :state => "approved"
    Forem::Topic.find_each do |topic|
      topic.update_column(:views_count, topic.views.sum(:count))
    end
    Forem::Topic.reset_column_information
    Forem::Topic.find_each {|t| t.save! }
  end
end