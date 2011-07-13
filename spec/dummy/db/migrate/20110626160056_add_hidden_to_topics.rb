class AddHiddenToTopics < ActiveRecord::Migration
  def change
    add_column :forem_topics, :hidden, :boolean, :default => false
  end
end
