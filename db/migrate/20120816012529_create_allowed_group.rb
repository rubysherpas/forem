class CreateAllowedGroup < ActiveRecord::Migration
  def change
    create_table :forem_allowed_groups do |t|
      t.integer :forum_id
      t.integer :group_id
    end

    add_index :forem_allowed_groups, :forum_id
  end
end
