class AddReplyToToForemPosts < ActiveRecord::Migration
  def change
    add_column :forem_posts, :reply_to_id, :integer
  end
end
