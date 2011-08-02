class RenameFldsForEvent < ActiveRecord::Migration
  def self.up
		rename_column :events, :start_date, :eventstartdate
		rename_column :events, :end_date, :eventenddate
    rename_column :events, :start_time, :eventstarttime
    rename_column :events, :end_time, :eventendtime
    rename_column :events, :overview, :bbody
    rename_column :events, :description, :cbody
    
  end

  def self.down
		rename_column :events, :eventenddate, :end_date
		rename_column :events, :eventstartdate, :start_date
    rename_column :events, :eventendtime, :end_time
    rename_column :events, :eventstarttime, :start_time
    rename_column :events, :bbody, :overview
    rename_column :events, :cbody, :description
  end
end
