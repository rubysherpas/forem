class AddPendingReviewToForemTopics < ActiveRecord::Migration
  def change
    add_column :forem_topics, :pending_review, :boolean, :default => true

    Forem::Topic.reset_column_information
    Forem::Topic.update_all :pending_review => false
  end
end
