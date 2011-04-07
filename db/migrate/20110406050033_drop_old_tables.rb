class DropOldTables < ActiveRecord::Migration
  def self.up
  	drop_table :user_prefs
  end

  def self.down
  end
end
