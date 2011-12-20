class AddLocationToEventNotice < ActiveRecord::Migration
  def self.up
    add_column :event_notices, :location, :string
  end

  def self.down
    remove_column :event_notices, :location
  end
end
