class CreateAdmins < ActiveRecord::Migration
  create_table :admins, :force => true do |t|
    t.string  :name,   :default => "",    :null => false
    t.string  :email,  :default => "",    :null => false
  end

  add_index :admins, :email, :unique => true
end
