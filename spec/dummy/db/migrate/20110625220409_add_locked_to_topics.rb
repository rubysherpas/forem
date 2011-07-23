class AddLockedToTopics < ActiveRecord::Migration
  def change
    add_column :forem_topics, :locked, :boolean
  end
end
