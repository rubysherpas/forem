class AddForemProtectedToForums < ActiveRecord::Migration
  def change
    add_column :forem_forums, :forem_protected, :boolean, :default => false unless column_exists?(:forem_forums, :forem_protected)
  end
end