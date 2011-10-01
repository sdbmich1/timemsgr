class CreateObservanceEvents < ActiveRecord::Migration
  def self.up
    create_table :observance_events do |t|
      t.string :event_name

      t.timestamps
    end
  end

  def self.down
    drop_table :observance_events
  end
end
