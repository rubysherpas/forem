module Forem
  class ModeratorGroup < ActiveRecord::Base
    include Tenacity
    
    t_belongs_to :forum, :inverse_of => :moderator_groups
    t_belongs_to :group

    attr_accessible :group_id
  end
end
