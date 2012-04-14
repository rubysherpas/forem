class AddForemAutoSubscribeToUser < ActiveRecord::Migration
  def change
    add_column :users, :forem_auto_subscribe, :boolean, :default => false
  end
end
