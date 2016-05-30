module Forem
  module Api
    module ApiHelper
      def api_id(model)
        model.respond_to?(:id) ? model.id : model
      end

      def api_has_one(json, relationship, type, model)
        json.set! relationship do
          json.data do
            json.type type
            json.id api_id(model)
          end
        end
      end

      def api_has_many(json, relationship, type, models)
        json.set! relationship do
          json.data models do |model|
            json.type type
            json.id api_id(model)

            yield model if block_given?
          end
        end
      end
    end
  end
end