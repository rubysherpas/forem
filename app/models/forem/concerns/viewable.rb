require 'active_support/concern'

module Forem
  module Concerns
    module Viewable
      extend ActiveSupport::Concern

      included do
        has_many :views, :as => :viewable, :dependent => :destroy,
          # dirty hack: workaround for rails 4.2.x, < 4.2.4 issue where activerecord
          # uses views_count as a counter cache for has_many relation on views
          # This should be removed once rails 4.2.4 is released and this bug fixed
          # Forem issue: https://github.com/radar/forem/issues/640
          # Rails issue: https://github.com/rails/rails/issues/19042
          counter_cache: :this_is_not_a_column_that_exists
      end

      def view_for(user)
        views.find_by(user_id: user.id)
      end

      # Track when users last viewed topics
      def register_view_by(user)
        return unless user
        view = views.find_or_create_by(user_id: user.id)
        view.increment!('count')
        increment!(:views_count)

        # update current_viewed_at if more than 15 minutes ago
        if view.current_viewed_at.nil?
          view.past_viewed_at = view.current_viewed_at = Time.now
        end

        # Update the current_viewed_at if it is BEFORE 15 minutes ago.
        if view.current_viewed_at < 15.minutes.ago
          view.past_viewed_at    = view.current_viewed_at
          view.current_viewed_at = Time.now
          view.save
        end
      end
    end
  end
end
