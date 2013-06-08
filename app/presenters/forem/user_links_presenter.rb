module Forem
  class UserLinksPresenter
    def initialize(context, users, alternate_text = 'None')
      self.context = context
      self.users = users
      self.alternate_text = alternate_text
    end

    def to_s
      if self.users.exists?
        self.users.map do |user|
          context.link_to user, [context.forem, :admin, user]
        end
      else
        self.alternate_text
      end
    end

    protected
    attr_accessor :context, :users, :alternate_text
  end
end
