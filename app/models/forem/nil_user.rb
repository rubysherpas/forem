module Forem
  class NilUser < Forem.user_class
    def forem_email
      "nobody@example.com"
    end

    def forem_name
      "[deleted]"
    end
  end
end
