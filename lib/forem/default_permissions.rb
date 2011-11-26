module Forem
  # Defines a whole bunch of permissions for Forem
  # Access (most) areas by default
  module DefaultPermissions
    extend ActiveSupport::Concern

    included do
      unless respond_to?(:can_read_forem_category?)
        def can_read_forem_category?(category)
          true
        end
      end

      unless respond_to?(:can_read_forem_forums?)
        def can_read_forem_forums?
          true
        end
      end

      unless respond_to?(:can_read_forem_forum?)
        def can_read_forem_forum?(forum)
          true
        end
      end
    end
  end
end
