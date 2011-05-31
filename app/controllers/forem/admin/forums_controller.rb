module Forem
  module Admin
    class ForumsController < BaseController
      def index
        @forums = Forum.all
      end

      def new
        @forum = Forem::Forum.new
      end

      def create
        @forum = Forem::Forum.new(params[:forum])
        if @forum.save
          flash[:notice] = t("forem.admin.forum.created")
          redirect_to @forum
        else
          flash[:error] = t("forem.admin.forum.not_created")
          render :action => "new"
        end
      end
    end
  end
end