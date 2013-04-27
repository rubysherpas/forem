class AddTopicsCountToForemForums < ActiveRecord::Migration
  def change
    add_column :forem_forums, :topics_count, :integer, :default => 0, :null => false

    Forem::Forum.reset_column_information

    if Forem::Forum.column_names.include? "topics_count"
      say_with_time "Setting initial `Forem::Forum.topics_count` values" do
        Forem::Forum.select(:id).find_each do |f|
          Forem::Forum.reset_counters f.id, :topics
        end
      end
    end
  end
end
