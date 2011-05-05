class AddTimeZonesToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :start_time_zone, :string, :limit => 255, :default => "UTC"
    add_column :events, :end_time_zone, :string, :limit => 255, :default => "UTC"
  end

  def self.down
    remove_column :events, :end_time_zone
    remove_column :events, :start_time_zone
  end
end
