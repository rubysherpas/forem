class AddLogoToForemForums < ActiveRecord::Migration
  def up
    add_attachment :forem_forums, :logo
  end
  
  def down
    remove_attachment :forem_forums, :logo
  end
end
