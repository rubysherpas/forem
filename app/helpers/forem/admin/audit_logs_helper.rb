module Forem
  module Admin
    module AuditLogsHelper
      def get_resource_path(resource)
        case resource.class.to_s
        when Forem::Category.to_s
          category_path(resource)
        when Forem::Forum.to_s
          forum_path(resource)
        when Forem::Topic.to_s
          topic_path(resource)
        when Forem::Post.to_s
          topic_post_path([resource.topic, resource])
        end

      rescue ActiveRecord::RecordNotFound
        nil
      end
      
      def resource_text(resource)
        case resource.class.to_s
        when Forem::Category.to_s
          resource
        when Forem::Forum.to_s
          resource
        when Forem::Topic.to_s
          resource
        when Forem::Post.to_s
          truncate(h(resource.text.html_safe), :length => 50)
          #resource
        end

      rescue ActiveRecord::RecordNotFound
        nil
      end
      
      def resource_path(resource)
        case resource.class.to_s
        when Forem::Category.to_s
          resource
        when Forem::Forum.to_s
          resource
        when Forem::Topic.to_s
          [resource.forum, resource]
        when Forem::Post.to_s
          [resource.topic, resource]
        end

      rescue ActiveRecord::RecordNotFound
        nil
      end
    end
  end
end
