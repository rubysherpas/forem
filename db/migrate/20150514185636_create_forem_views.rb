class CreateForemViews < ActiveRecord::Migration
  def change
    create_table :forem_views do |t|
      t.integer  :user_id
      t.integer  :viewable_id
      t.string   :viewable_type
      t.datetime :created_at

      t.datetime :updated_at
      t.integer  :count, :default => 0 # ?
      t.datetime :current_viewed_at
      t.datetime :past_viewed_at
      t.index    :user_id
      t.index    :viewable_id
      t.index    :updated_at
    end
  end
end