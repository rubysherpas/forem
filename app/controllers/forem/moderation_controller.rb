module Forem
  class ModerationController < ApplicationController
    helper 'forem/posts'

    def index
      @posts = Post.pending_review.topic_not_pending_review
      @topics = Topic.pending_review
    end

    def post
      post = Post.find(params[:id])
    end

    private

    def forum
      @forum = Forum.find(params[:id])
    end

    helper_method :forum
  end
end
