module Forem
  class Group < ActiveRecord::Base
    validates :name, :presence => true

    has_many :memberships
    #t_has_many :members, :through => :memberships, :class_name => Forem.user_class.to_s

    attr_accessible :name
    
    def members
      []
    end

    def to_s
      name
    end
  end
end
