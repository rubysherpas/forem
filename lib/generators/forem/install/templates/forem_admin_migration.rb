class AddForemAdmin < ActiveRecord::Migration

  def change
    add_column <%= user_class.constantize.table_name.to_sym.inspect %>, :forem_admin, :boolean, :default => false
  end
end
