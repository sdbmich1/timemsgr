class RenameDbcol < ActiveRecord::Migration
  def self.up
		rename_column :event_types, :type, :type_code
  end

  def self.down
		rename_column :event_types, :type_code, :type
  end
end
