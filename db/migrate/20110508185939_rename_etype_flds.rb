class RenameEtypeFlds < ActiveRecord::Migration
  def self.up
		rename_column :event_types, :type_code, :Code
  end

  def self.down
		rename_column :event_types, :Code, :type_code
  end
end
