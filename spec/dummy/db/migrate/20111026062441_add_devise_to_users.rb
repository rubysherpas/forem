class AddDeviseToUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.database_authenticatable :null => false
    end

    add_index :users, :email,                :unique => true
  end

  def self.down
    drop_table :users
  end
end
