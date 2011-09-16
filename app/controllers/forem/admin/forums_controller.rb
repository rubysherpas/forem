module Forem
  module Admin
    class ForumsController < BaseController
      before_filter :find_forum, :only => [:edit, :update, :destroy]

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
          redirect_to admin_forums_path
        else
          flash.now.alert = t("forem.admin.forum.not_created")
          render :action => "new"
        end
      end

      def edit

      end

      def update
        if @forum.update_attributes(params[:forum])
          flash[:notice] = t("forem.admin.forum.updated")
          redirect_to admin_forums_path
        else
          flash.now.alert = t("forem.admin.forum.not_updated")
          render :action => "edit"
        end
      end

      def destroy
        @forum.destroy
        flash[:notice] = t("forem.admin.forum.deleted")
        redirect_to admin_forums_path
      end

      private

        def find_forum
          @forum = Forem::Forum.find(params[:id])
        end

    end
  end
end