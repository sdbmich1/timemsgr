class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.string :title
      t.string :description
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.string :type
      t.string :frequency
      t.string :location
      t.integer :start_time_zone_id
      t.integer :end_time_zone_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
