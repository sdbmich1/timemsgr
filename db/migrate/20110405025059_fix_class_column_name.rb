class FixClassColumnName < ActiveRecord::Migration
  def self.up
  	 rename_column :channels, :class, :channel_class
  	 rename_column :channels, :type, :channel_type
  end

  def self.down
  end
end
