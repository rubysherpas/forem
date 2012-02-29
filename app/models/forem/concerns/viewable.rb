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
        end
      end
    end
  end
end
