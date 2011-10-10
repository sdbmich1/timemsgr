class CreateEventTracks < ActiveRecord::Migration
  def self.up
    create_table :event_tracks do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :event_tracks
  end
end
