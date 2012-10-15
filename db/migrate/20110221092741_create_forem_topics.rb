class CreateForemTopics < ActiveRecord::Migration
  def change
    create_table :forem_topics do |t|
      t.integer :forum_id
      t.string :user_id
      t.string :subject

      t.timestamps
    end
  end
end
