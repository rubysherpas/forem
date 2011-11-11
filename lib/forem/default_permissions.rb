module Forem
  # Defines a whole bunch of permissions for Forem
  # Access (most) areas by default
  module DefaultPermissions
    extend ActiveSupport::Concern

    module InstanceMethods
      def can_read_forums?
        true
      end
    end
  end
end
