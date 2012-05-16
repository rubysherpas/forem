class CreateUsers < ActiveRecord::Migration
  create_table :users, :force => true do |t|
    t.string  :email,                             :default => "",    :null => false
    t.string  :encrypted_password, :limit => 128, :default => "",    :null => false
    t.string  :login
    t.boolean :forem_admin,                       :default => false
    t.string :forem_state, :default => "pending_review"
    t.string :users, :custom_avatar_url
  end

  add_index :users, :email, :unique => true
end
