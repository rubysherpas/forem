class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login
      t.boolean :forem_admin, :default => false
    end
  end
end