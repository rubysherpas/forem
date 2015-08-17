class CreateForemMemberships < ActiveRecord::Migration
  def change
    create_table :forem_memberships do |t|
      t.integer :group_id
      t.integer :member_id

      t.index :group_id
    end
  end
end
