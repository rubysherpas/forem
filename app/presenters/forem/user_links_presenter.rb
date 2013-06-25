module Forem
  class UserLinksPresenter
    def initialize(context, users, alternate_text = 'None')
      self.context = context
      self.users = users
      self.alternate_text = alternate_text
    end

    def to_s
      return self.alternate_text unless self.users.exists?

      self.users.map { |user| link_to user, [forem, :admin, user] }
    end

    protected
    attr_accessor :context, :users, :alternate_text
    delegate :forem, :link_to, :to => :context
  end
end
