class ForemFriendlyId < ActiveRecord::Migration
  def up
    %w(Forum Topic Category).each do |model_name|
      model = "Forem::#{model_name}".constantize
      table_name = model.table_name
      add_column table_name, :slug, :string
      add_index table_name, :slug, unique: true
      model.reset_column_information
      model.find_each(&:save)
    end
  end

  def down
    %w(Forum Topic Category).each do |model_name|
      remove_column "Forem::#{model_name}".constantize.table_name, :slug
    end
  end
end
