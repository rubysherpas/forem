class CreateForemCategories < ActiveRecord::Migration
  def change
    create_table :forem_categories do |t|
      t.string :name, :null => false
      t.timestamps
    end
    Forem::Category.reset_column_information
    Forem::Category.create(:name => 'General')
  end
end
