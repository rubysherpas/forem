class AddForemState < ActiveRecord::Migration

  def change
    add_column <%= user_class.constantize.table_name.to_sym.inspect %>, :forem_state, :string, :default => 'pending_review'
  end
end
