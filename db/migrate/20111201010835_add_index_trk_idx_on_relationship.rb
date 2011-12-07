class AddIndexTrkIdxOnRelationship < ActiveRecord::Migration
  def self.up
    add_index :relationships, :tracker_id
    add_index :relationships, :tracked_id
    add_index :relationships, [:tracker_id, :tracked_id], :unique => true
  end

  def self.down
  end
end
