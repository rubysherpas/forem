class AddAccountIdToForemCategories < ActiveRecord::Migration
  def change
    add_column :forem_categories, :account_id, :integer
  end
end
