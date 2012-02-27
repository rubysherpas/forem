class CreateForemGroups < ActiveRecord::Migration
  def change
    create_table :forem_groups do |t|
      t.string :name
    end

    add_index :forem_groups, :name
  end
end
