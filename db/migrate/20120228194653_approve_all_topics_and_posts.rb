class ApproveAllTopicsAndPosts < ActiveRecord::Migration
  def up
    Forem::Topic.find_each { |t| t.update_attribute(:state => "approved") }
    Forem::Post.find_each { |p| p.update_attribute(:state => "approved") }
  end

  def down
  end
end

