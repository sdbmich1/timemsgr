class AddLocationToNotification < ActiveRecord::Migration
  def self.up
    add_column :notifications, :location, :string
  end

  def self.down
    remove_column :notifications, :location
  end
end
