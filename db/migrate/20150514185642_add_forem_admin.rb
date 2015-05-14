# This migration comes from forem (originally 20120616193446)
class AddForemAdmin < ActiveRecord::Migration
  def change
    unless column_exists?(user_class, :forem_admin)
      add_column user_class, :forem_admin, :boolean, :default => false
    end

    unless column_exists?(user_class, :forem_state)
      add_column user_class, :forem_state, :string, :default => 'pending_review'
    end

    unless column_exists?(user_class, :forem_auto_subscribe)
      add_column user_class, :forem_auto_subscribe, :boolean, :default => false
    end
  end

  def user_class
    Forem.user_class.table_name.downcase.to_sym
    Forem.user_class.table_name.downcase.to_sym
    Forem.user_class.table_name.downcase.to_sym
  end
end