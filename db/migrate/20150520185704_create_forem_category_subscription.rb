class CreateForemCategorySubscription < ActiveRecord::Migration
  def change
    create_table :forem_category_subscriptions do |t|
      t.integer :monitor_id
      t.integer :category_id
    end
  end
end
