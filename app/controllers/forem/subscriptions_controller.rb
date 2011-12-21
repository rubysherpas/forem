module Forem
  class SubscriptionsController < ApplicationController
    before_filter :authenticate_forem_user
		before_filter :find_topic

		def create
			@topic.subscribe_user(forem_user.id)
			flash[:notice] = t("forem.topic.subscribed")
			redirect_to :back
		end

		def destroy
			@subscription = Subscription.find(params[:id])
			@subscription.destroy
			flash[:notice] = t("forem.topic.unsubscribed")
			redirect_to :back
		end

    private

    def find_topic
      @topic = Forem::Topic.find(params[:topic_id])
    end
  end
end
