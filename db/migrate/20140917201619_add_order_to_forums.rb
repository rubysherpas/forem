class AddPositionToForums < ActiveRecord::Migration
  def change
    add_column :forem_forums, :position, :integer, :default => 0
  end
end
