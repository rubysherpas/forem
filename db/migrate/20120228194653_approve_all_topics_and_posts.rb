class ApproveAllTopicsAndPosts < ActiveRecord::Migration
  def up
    Forem::Topic.update_all :state => "approved"
    Forem::Post.update_all :state => "approved"
  end

  def down
  end
end

