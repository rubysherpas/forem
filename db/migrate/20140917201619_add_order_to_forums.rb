class AddOrderToForums < ActiveRecord::Migration
  def change
    add_column :forem_forums, :order, :integer, :default => 0
  end
end
