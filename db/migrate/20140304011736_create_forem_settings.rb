class CreateForemSettings < ActiveRecord::Migration
  def change
    create_table :forem_settings do |t|
      t.integer :account_id
      t.integer :user_id
      t.text :settings

      t.timestamps
    end
  end
end
