class ApproveAllTopicsAndPosts < ActiveRecord::Migration
  # Stub out Forem::Post.notified?
  Forem::Post
  class Forem::Post < ActiveRecord::Base
    def notified?
      true
    end
  end

  def up
    Forem::Topic.find_each { |t| t.approve! }
    Forem::Post.find_each { |t| t.approve! }
  end

  def down
  end
end

