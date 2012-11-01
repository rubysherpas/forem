class CreateForemAuditLogs < ActiveRecord::Migration
  def change
    create_table :forem_audit_logs do |t|
      t.integer :user_id
      t.integer :resource_id
      t.string :resource_type
      t.string :resource_action
      t.string :action_type
      t.string :user_ip

      t.timestamps
    end
  end
end
