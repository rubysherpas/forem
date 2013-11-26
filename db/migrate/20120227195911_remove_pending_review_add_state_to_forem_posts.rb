class RemovePendingReviewAddStateToForemPosts < ActiveRecord::Migration
  def up
    remove_column :forem_posts, :pending_review
    add_column :forem_posts, :state, :string, :default => 'pending_review'
    add_index :forem_posts, :state
  end

  def down
    remove_index :forem_posts, :state
    remove_column :forem_posts, :state
    add_column :forem_posts, :pending_review, :boolean, :default => true

    Forem::Post.reset_column_information
    Forem::Post.update_all :pending_review => false
  end
end
