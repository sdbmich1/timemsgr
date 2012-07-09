class CreateTravelModes < ActiveRecord::Migration
  def self.up
    create_table :travel_modes do |t|
      t.string :travel_type
      t.string :hide
      t.string :status
      t.string :description
      t.integer :sortkey

      t.timestamps
    end
  end

  def self.down
    drop_table :travel_modes
  end
end
