module Forem
  class Membership < ActiveRecord::Base
    belongs_to :group
    belongs_to :member, :class_name => Forem.user_class.to_s
  end
end
