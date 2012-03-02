require 'active_support/concern'

module Forem
  module Concerns
    module Viewable
      extend ActiveSupport::Concern

      included do
        has_many :views, :as => :viewable
      end

      def view_for(user)
        views.find_by_user_id(user.id)
      end

      # Track when users last viewed topics
      def register_view_by(user)
        if user
          view = views.find_or_create_by_user_id(user.id)
          view.increment!("count")
          increment!(:views_count)

          # update current viewed at if more than 15 minutes ago
          if view.current_viewed_at < 15.minutes.ago
            view.past_viewed_at = view.current_viewed_at
            view.current_viewed_at = Time.now
            view.save
          end
        end
      end
    end
  end
end
