class RenameTitleToNameOnForemForums < ActiveRecord::Migration
  def up
    rename_column :forem_forums, :title, :name
  end
end
