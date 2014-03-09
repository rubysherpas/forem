class AddAccountIdToForemForums < ActiveRecord::Migration
  def change
    add_column :forem_forums, :account_id, :integer
    add_index :forem_forums, :account_id
  end
end
