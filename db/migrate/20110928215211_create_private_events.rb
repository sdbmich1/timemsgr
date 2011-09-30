class CreatePrivateEvents < ActiveRecord::Migration
  def self.up
    create_table :private_events do |t|
      t.string :event_name
      t.timestamps
    end
  end

  def self.down
    drop_table :private_events
  end
end
