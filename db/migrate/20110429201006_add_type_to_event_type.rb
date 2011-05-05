class AddTypeToEventType < ActiveRecord::Migration
  def self.up
    add_column :event_types, :type, :string
  end

  def self.down
    remove_column :event_types, :type
  end
end
