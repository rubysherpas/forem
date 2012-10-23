class AddForemMod < ActiveRecord::Migration
  def change
    unless column_exists?(user_class, :forem_mod)
      add_column user_class, :forem_mod, :boolean, :default => false
    end
  end

  def user_class
    Forem.user_class.table_name.downcase.to_sym
  end
end
