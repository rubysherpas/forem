class UpdateTopicsUpdatedAt < ActiveRecord::Migration
  def up
    Forem::Topic.includes(:posts).find_each do |t|
      t.update_attribute(:last_post_at, t.posts.last.created_at)
    end
  end

  def down
    Forem::Topic.find_each do |t|
      t.update_attribute(:last_post_at, t.created_at)
    end
  end
end
