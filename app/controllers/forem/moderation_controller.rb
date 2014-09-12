module Forem
  class ModerationController < Forem::ApplicationController
    before_filter :ensure_moderator_or_admin

    helper 'forem/posts'

    def index
      @posts = forum.posts.pending_review
      @topics = forum.topics.pending_review
    end

    def posts
      Forem::Post.moderate!(params[:posts] || [])
      flash[:notice] = t('forem.posts.moderation.success')
      redirect_to :back
    end

    def topic
      if params[:topic]
        topic = forum.topics.friendly.find(params[:topic_id])
        topic.moderate!(params[:topic][:moderation_option])
        flash[:notice] = t("forem.topic.moderation.success")
      else
        flash[:error] = t("forem.topic.moderation.no_option_selected")
      end
      redirect_to :back
    end

    private

    def forum
      @forum = Forem::Forum.friendly.find(params[:forum_id])
    end

    helper_method :forum

    def ensure_moderator_or_admin
      unless forem_admin? || forum.moderator?(forem_user)
        raise CanCan::AccessDenied
      end
    end

  end
end
