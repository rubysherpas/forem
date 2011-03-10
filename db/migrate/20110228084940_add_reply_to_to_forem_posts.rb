class AddReplyToToForemPosts < ActiveRecord::Migration
  def self.up
    add_column :forem_posts, :reply_to_id, :integer
  end
end
