module Forem
  class NilUser
    def email
      "nobody@example.com"
    end

    def to_s
      "[deleted]"
    end
  end
end