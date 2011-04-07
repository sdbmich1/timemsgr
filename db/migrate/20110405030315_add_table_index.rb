class AddTableIndex < ActiveRecord::Migration
  def self.up
  	add_index :channel_interests, [ :channel_id, :interest_id ], :unique => true
  	add_index :channels, :location_id
  end

  def self.down
  end
end
