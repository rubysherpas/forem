module Forem
  module Admin
    module TopicsHelper
      def forem_admin_topic_links(topic)
        if forem_admin?
          link_to(t(".hide.#{topic.hidden}"), forem.toggle_hide_admin_topic_path(topic), :method => :put) +
          link_to(t(".lock.#{topic.locked}"), forem.toggle_lock_admin_topic_path(topic), :method => :put) +
          link_to(t(".pin.#{topic.pinned}"), forem.toggle_pin_admin_topic_path(topic), :method => :put)
        end
      end
    end
  end
end
