module Forem
  module UrlSlug
    def self.included(base)
      base.extend ClassMethods
    end

    def to_param
      "#{to_s.parameterize}-#{id}"
    end

    module ClassMethods
      def id_from_param(param)
        param.sub(/^\D*/, '').to_i
      end

      def find_by_slug(param)
        find_by_id id_from_param(param)
      end

      def find_by_slug!(param)
        find_by_id! id_from_param(param)
      end
    end
  end
end