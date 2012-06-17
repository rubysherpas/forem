# This migration comes from forem (originally 20120616000935)
class AddForemAutoSubscribe < ActiveRecord::Migration
  def change
    unless column_exists?(user_class, :forem_admin)
      add_column user_class, :forem_auto_subscribe, :boolean, :default => false
    end
  end

  def user_class
    ActiveSupport::Inflector.pluralize(Forem.user_class.name.downcase).to_sym
  end
end