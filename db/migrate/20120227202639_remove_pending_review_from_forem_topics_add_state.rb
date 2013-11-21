class RemovePendingReviewFromForemTopicsAddState < ActiveRecord::Migration
  def up
    remove_column :forem_topics, :pending_review
    add_column :forem_topics, :state, :string, :default => 'pending_review'
    add_index :forem_topics, :state
  end

  def down
    remove_index :forem_topics, :state
    remove_column :forem_topics, :state
    add_column :forem_topics, :pending_review, :boolean, :default => true

    Forem::Topic.reset_column_information
    Forem::Topic.update_all :pending_review => false
  end
end
