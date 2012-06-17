# This migration comes from forem (originally 20120616000135)
class AddForemAdmin < ActiveRecord::Migration
  def change
    unless column_exists?(user_class, :forem_admin)
      add_column user_class, :forem_admin, :boolean, :default => false
    end
  end
  
  def user_class
    ActiveSupport::Inflector.pluralize(Forem.user_class.name.downcase).to_sym
  end
end
