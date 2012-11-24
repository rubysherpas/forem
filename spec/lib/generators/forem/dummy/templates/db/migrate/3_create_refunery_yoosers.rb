class CreateRefuneryYoosers < ActiveRecord::Migration
  create_table :refunery_yoosers, :force => true do |t|
    t.string  :name,   :default => "",    :null => false
    t.string  :email,  :default => "",    :null => false
  end

  add_index :refunery_yoosers, :email, :unique => true
end
