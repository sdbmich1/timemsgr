class CreateTravelModes < ActiveRecord::Migration
  def self.up
  end

  def self.down
    drop_table :travel_modes
  end
end
