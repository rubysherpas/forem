module Forem
  module UserExtensions
    def self.included(base)
      Forem::Topic.belongs_to :user, :class_name => base.to_s 
      Forem::Post.belongs_to :user, :class_name => base.to_s

      # FIXME: Obviously terrible, temp to get further
      def forem_admin?
        %w(refinery superuser).detect do |r|
          has_role?(r)
        end
      end
    end
  end
  
end
