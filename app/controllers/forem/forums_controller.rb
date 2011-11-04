module Forem
  class ForumsController < Forem::ApplicationController
    helper 'forem/topics'

    def index
      @forums = Forem::Forum.select("forem_forums.*, forem_categories.name as cat_name, forem_categories.id AS cat_id").joins(:category)
    end

    def show
      @forum = Forem::Forum.find(params[:id])
      @topics = forem_admin? ? @forum.topics : @forum.topics.visible
      @topics = @topics.by_pinned_or_most_recent_post.page(params[:page]).per(20)
    end
  end
end
