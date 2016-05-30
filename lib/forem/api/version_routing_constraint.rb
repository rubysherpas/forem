module Forem
  module API
    class VersionRoutingConstraint
      def initialize(version)
        @version = version
      end

      def matches?(request)
        requested_this_version?(request) ||
          # All real clients should specify an API version in their
          # request headers, but for ease of debugging (via curl, browsers,
          # etc.), the latest API version responds to requests that don't
          # specify.
          (no_requested_version?(request) && latest_version?)
      end

      private

      def requested_this_version?(request)
        requested_version(request) == @version
      end

      def no_requested_version?(request)
        !requested_version(request)
      end

      def requested_version(request)
        accept = request.headers['Accept']
        accept &&
          accept[/application\/vnd\.forem\+json; version=([0-9]+)/] &&
          Integer($1)
      end

      # True if no later API version exists.
      def latest_version?
        "::Forem::Api::V#{@version + 1}".constantize
        # if the above succeeds, this is not the latest version
        false
      rescue NameError
        # no version beyond this one exists
        true
      end
    end
  end
end