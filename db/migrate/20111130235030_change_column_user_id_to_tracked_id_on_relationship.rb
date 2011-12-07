class ChangeColumnUserIdToTrackedIdOnRelationship < ActiveRecord::Migration
  def self.up
		rename_column :relationships, :user_id, :tracked_id
  end

  def self.down
		rename_column :relationships, :tracked_id, :user_id
  end
end
