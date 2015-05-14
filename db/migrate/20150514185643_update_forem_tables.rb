class UpdateForemTables < ActiveRecord::Migration
	def up
		# forem_forums
		Forem::Forum.find_each do |forum|
			forum.update_column(:views_count, forum.topics.sum(:views_count))
		end

		# forem_topics
		Forem::Topic.reset_column_information
		Forem::Topic.includes(:posts).find_each do |t|
			post = t.posts.last
			t.update_attribute(:last_post_at, post.updated_at)
		end
		Forem::Topic.update_all :state => "approved"
		Forem::Topic.find_each do |topic|
			topic.update_column(:views_count, topic.views.sum(:count))
		end

		# forem_posts
		Forem::Post.reset_column_information
		Forem::Post.update_all :state => "approved"
	end

	def down

	end

	def change
		# forem_forums
		if Forem::Forum.count > 0
			Forem::Forum.update_all :category_id => Forem::Category.first.id
		end
		Forem::Forum.reset_column_information
		Forem::Forum.find_each {|t| t.save! }

		# forem_topics
		Forem::Topic.reset_column_information
		Forem::Topic.find_each {|t| t.save! }

		# forem_views
		Forem::View.update_all("viewable_type='Forem::Topic'")

		# forem_categories
		Forem::Category.reset_column_information
		Forem::Category.find_each {|t| t.save! }
	end
end