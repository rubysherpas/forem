class UpdateTopicsUpdatedAt < ActiveRecord::Migration
  def up
    Forem::Topic.includes(:posts).find_each do |t|
      post = t.posts.last
      t.update_attribute(:updated_at, post.updated_at)
    end
  end

  def down
    Forem::Topic.find_each do |t|
      t.update_attribute(:updated_at, t.created_at)
    end
  end
end
