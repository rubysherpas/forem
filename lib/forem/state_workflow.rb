require 'workflow'

module Forem
  module StateWorkflow
    def self.included(base)
      base.class_eval do
        workflow_column :state
        workflow do
          state :pending_review do
            event :spam,    :transitions_to => :spam
            event :approve, :transitions_to => :approved
          end
          state :spam
          state :approved do
            event :approve, :transitions_to => :approved
          end
        end
      end
    end
  end
end
