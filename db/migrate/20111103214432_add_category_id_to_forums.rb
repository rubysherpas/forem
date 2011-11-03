class AddCategoryIdToForums < ActiveRecord::Migration
  def change
    add_column :forem_forums, :category_id, :integer

    if Forem::Forum.count > 0
      Forem::Forum.update_all :category_id => 1
    end
  end
end
