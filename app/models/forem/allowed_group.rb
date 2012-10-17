module Forem
  class AllowedGroup < ActiveRecord::Base
    belongs_to :forum, :inverse_of => :allowed_groups
    belongs_to :group

    attr_accessible :group_id
  end
end
