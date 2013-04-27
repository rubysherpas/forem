class AddPostsCountToForemForums < ActiveRecord::Migration
  def change
    add_column :forem_forums, :posts_count, :integer, :default => 0, :null => false

    Forem::Forum.reset_column_information

    if Forem::Forum.column_names.include? "posts_count"
      say_with_time "Setting initial `Forem::Forum.posts_count` values" do
        Forem::Forum.select(:id).find_each do |f|
          f.update_column :posts_count, f.topics.inject(0) { |s,t| s += t.posts.count }
        end
      end
    end

  end
end
