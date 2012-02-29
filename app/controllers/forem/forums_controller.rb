module Forem
  class ForumsController < Forem::ApplicationController
    load_and_authorize_resource :only => :show
    helper 'forem/topics'

    def index
      @categories = Forem::Category.all
    end

    def show
      @forum = Forem::Forum.find(params[:id])
      register_view
      @topics = forem_admin? ? @forum.topics : @forum.topics.visible
      @topics = @topics.by_pinned_or_most_recent_post.page(params[:page]).per(20)
    end

    private
    def register_view
      @forum.register_view_by(forem_user)
    end
  end
end
