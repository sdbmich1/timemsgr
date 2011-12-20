class AddUserIdToEventNotice < ActiveRecord::Migration
  def self.up
    add_column :event_notices, :user_id, :integer
    add_index :event_notices, [:user_id]
  end

  def self.down
    remove_column :event_notices, :user_id
  end
end
