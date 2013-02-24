class AddPostsApprovedCountToForemForums < ActiveRecord::Migration
  def change
    add_column :forem_forums, :posts_approved_count, :integer, :default => 0, :null => false

    Forem::Forum.reset_column_information

    if Forem::Forum.column_names.include? "posts_approved_count"
      say_with_time "Setting initial `Forem::Forum.posts_approved_count` values" do
        Forem::Forum.select(:id).find_each do |f|
          posts_approved_count = f.topics.inject(0) do |s,t|
            s += t.posts.approved.count
          end

          f.update_column :posts_approved_count, posts_approved_count
        end
      end
    end

  end
end
