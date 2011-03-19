module Forem
  module UserExtensions
    def self.included(base)
      Forem::Topic.belongs_to :user, :class_name => base.to_s 
      Forem::User.belongs_to :user, :class_name => base.to_s
    end
  end
  
end