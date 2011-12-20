class AddEventIdToNotification < ActiveRecord::Migration
  def self.up
    add_column :notifications, :event_id, :integer
  end

  def self.down
    remove_column :notifications, :event_id
  end
end
