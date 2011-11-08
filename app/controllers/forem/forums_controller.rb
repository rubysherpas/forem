module Forem
  class ForumsController < Forem::ApplicationController
    load_and_authorize_resource
    helper 'forem/topics'

    def index
      @forums = Forem::Forum.select("#{Forem::Forum.quoted_table_name}.*,#{Forem::Category.quoted_table_name} as cat_name,#{Forem::Category.quoted_table_name}.id AS cat_id").joins(:category)
    end

    def show
      @forum = Forem::Forum.find(params[:id])
      @topics = forem_admin? ? @forum.topics : @forum.topics.visible
      @topics = @topics.by_pinned_or_most_recent_post.page(params[:page]).per(20)
    end

    private
      def current_ability
        Forem::Ability.new(forem_user)
      end
  end
end
