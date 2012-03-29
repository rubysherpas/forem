class AddNotifiedToForemPosts < ActiveRecord::Migration
  def change
    add_column :forem_posts, :notified, :boolean, :default => false
  end
end
