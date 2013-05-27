module Forem
  module Concerns
    module NilUser
      def user
        forem_user || Forem::NilUser.new
      end

      def user=(user)
        self.forem_user = user
      end
    end
  end
end