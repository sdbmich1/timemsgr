class AddStatusToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :status, :string
    add_column :events, :hide, :string
    rename_column :events, :type, :event_type
    rename_column :events, :name, :event_name
   
  end

  def self.down
    remove_column :events, :status
  end
end
