class AddForemAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :forem_admin, :boolean, :default => false
  end
end
