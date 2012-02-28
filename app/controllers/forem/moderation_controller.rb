module Forem
  class ModerationController < Forem::ApplicationController
    before_filter :ensure_moderator_or_admin

    helper 'forem/posts'

    def index
      @posts = forum.posts.pending_review.topic_not_pending_review
      @topics = forum.topics.pending_review
    end

    def posts
      Post.moderate!(params[:posts] || [])
      flash[:notice] = t('forem.posts.moderation.success')
      redirect_to :back
    end

    private

    def forum
      @forum = Forum.find(params[:forum_id])
    end

    helper_method :forum

    def ensure_moderator_or_admin
      unless forum.moderator?(forem_user) || forem_admin?
        raise CanCan::AccessDenied
      end
    end

  end
end
