class ApproveAllTopicsAndPosts < ActiveRecord::Migration
  def up
    Forem::Topic.find_each { |t| t.approve! }
    Forem::Post.find_each { |t| t.approve! }
  end

  def down
  end
end
