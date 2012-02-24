module Forem
  class ModerationController < ApplicationController
    helper 'forem/posts'

    def index
      @posts = Post.pending_review.topic_not_pending_review
      @topics = Topic.pending_review
    end

    def posts
      Post.moderate!(params[:posts] || [])
      flash[:notice] = t('forem.posts.moderation.success')
      redirect_to forum_moderator_tools_path(forum)
    end

    private

    def forum
      @forum = Forum.find(params[:forum_id])
    end

    helper_method :forum
  end
end
