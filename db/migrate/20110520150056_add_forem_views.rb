class AddForemViews < ActiveRecord::Migration
  def change
    create_table :forem_views do |t|
      t.string :user_id
      t.integer :topic_id
      t.datetime :created_at
    end
  end
end
