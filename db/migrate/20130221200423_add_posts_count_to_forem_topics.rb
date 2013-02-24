class AddPostsCountToForemTopics < ActiveRecord::Migration
  def change
    add_column :forem_topics, :posts_count, :integer, :default => 0, :null => false

    Forem::Topic.reset_column_information

    if Forem::Topic.column_names.include? "posts_count"
      say_with_time "Setting initial `Forem::Topic.posts_count` values" do
        Forem::Topic.select(:id).find_each do |t|
          Forem::Topic.reset_counters t.id, :posts
        end
      end
    end

  end
end
