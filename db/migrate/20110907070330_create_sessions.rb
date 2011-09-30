class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :event_sessions do |t|
      t.string :name
      t.string :topic
      t.date :startdate
      t.date :enddate
      t.time :starttime
      t.time :endtime
      t.integer :event_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :event_sessions
  end
end
