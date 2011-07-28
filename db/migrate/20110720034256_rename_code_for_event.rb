class RenameCodeForEvent < ActiveRecord::Migration
  def self.up
		rename_column :events, :event_type, :Code
  end

  def self.down
		rename_column :events, :Code, :event_type
  end
end
