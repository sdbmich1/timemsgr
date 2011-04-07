class FixColumnName < ActiveRecord::Migration
  def self.up
  	 rename_column :channels, :status, :channel_status
  	 rename_column :channels, :scope, :channel_scope
  end

  def self.down
  end
end
