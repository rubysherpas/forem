class AddForemFilesTable < ActiveRecord::Migration
  def change
    create_table :forem_files do |t|
      t.integer :owner_id, null: false
      t.string  :owner_type, null: false
      t.string  :file, null: false

      t.timestamps
    end

    add_index :forem_files, [:owner_id, :owner_type]
  end
end
