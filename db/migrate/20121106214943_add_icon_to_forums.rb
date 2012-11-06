class AddIconToForums < ActiveRecord::Migration
  def change
    add_column :forem_forums, :icon, :string unless column_exists?(:forem_forums, :icon)
  end
end
