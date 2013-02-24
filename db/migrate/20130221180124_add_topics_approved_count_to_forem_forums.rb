class AddTopicsApprovedCountToForemForums < ActiveRecord::Migration
  def change
    add_column :forem_forums, :topics_approved_count, :integer, :default => 0, :null => false

    Forem::Forum.reset_column_information

    if Forem::Forum.column_names.include? "topics_approved_count"
      say_with_time "Setting initial `Forem::Forum.topics_approved_count` values" do
        Forem::Forum.select(:id).find_each do |f|
          f.update_column :topics_approved_count, f.topics.approved.count
        end
      end
    end

  end
end
