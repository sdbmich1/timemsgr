class CreateCalendarEvents < ActiveRecord::Migration
  def self.up
    create_table :calendar_events do |t|
      t.integer :calendar_id
      t.integer :event_id
      t.date :start_date
      t.date :end_date
      t.date :original_start_date
      t.string :status

      t.timestamps
    end
    
    add_index :calendar_events, [:calendar_id, :event_id], :unique => true
  end

  def self.down
    drop_table :calendar_events
  end
end
