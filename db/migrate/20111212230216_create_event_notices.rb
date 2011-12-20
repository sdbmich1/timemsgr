class CreateEventNotices < ActiveRecord::Migration
  def self.up
    create_table :event_notices do |t|
      t.integer :event_id
      t.string :Notice_ID
      t.string :Notice_type, :limit => 20
      t.string :Notice_Text
      t.string :event_type, :limit => 20
      t.string :event_name
      t.string :eventid
      t.datetime :eventstartdate
      t.datetime :eventstarttime
      t.datetime :eventenddate
      t.datetime :eventendtime
      t.string :sourceID
      t.string :sourceURL
      t.string :status
      t.string :hide
      t.integer :sortkey

      t.timestamps
    end
    add_index :event_notices, [:sourceID]
    add_index :event_notices, [:event_id, :event_type, :sourceID]
  end

  def self.down
    drop_table :event_notices
  end
end
