class CreateForemCategories < ActiveRecord::Migration
 def change
    create_table :forem_categories do |t|
      t.string :name, :null => false
      t.timestamps
    end
   execute <<-SQL
       INSERT INTO forem_categories(name) VALUES('General');
     SQL
  end
end
