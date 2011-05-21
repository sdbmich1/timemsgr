class AddUserIdToEventphoto < ActiveRecord::Migration
  def self.up
    add_column :event_photos, :user_id, :integer
  end

  def self.down
    remove_column :event_photos, :user_id
  end
end
