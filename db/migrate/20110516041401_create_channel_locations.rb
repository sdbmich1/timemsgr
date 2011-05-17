class CreateChannelLocations < ActiveRecord::Migration
  def self.up
    create_table :channel_locations do |t|
      t.integer :location_id
      t.integer :channel_id

      t.timestamps
    end
		add_index :channel_locations, :location_id
		add_index :channel_locations, :channel_id
  end

  def self.down
		remove_index :channel_locations, :channel_id
		remove_index :channel_locations, :location_id
    drop_table :channel_locations
  end
end
