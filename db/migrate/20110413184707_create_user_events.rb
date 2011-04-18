class CreateUserEvents < ActiveRecord::Migration
  def self.up
    create_table :user_events do |t|
      t.integer :user_id
      t.integer :event_id

      t.timestamps
    end
    
    add_index :user_events, :user_id
    add_index :user_events, :event_id
    add_index :user_events, [:user_id, :event_id], :unique => true
  end

  def self.down
    drop_table :user_events
  end
end
