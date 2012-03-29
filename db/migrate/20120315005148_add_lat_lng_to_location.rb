class AddLatLngToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :lat, :decimal, :precision => 15, :scale => 10
    add_column :locations, :lng, :decimal, :precision => 15, :scale => 10
    add_index :locations, :lat, :name => "loc_lat_idx"
    add_index :locations, :lng, :name => "loc_lng_idx"
		add_index :locations, [:lat, :lng], :name => "loc_latlng_idx"
  end

  def self.down
    remove_index :locations, :name => :loc_latlng_idx
    remove_index :locations, :name => :loc_lng_idx
    remove_index :locations, :name => :loc_lat_idx
    remove_column :locations, :lng
    remove_column :locations, :lat
  end
end
