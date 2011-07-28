class AddPhotoFileNameToEventType < ActiveRecord::Migration
  def self.up
    add_column :event_types, :photo_file_name, :string
    
		add_index :event_types, :Code
  end

  def self.down
		remove_index :event_types, :Code
    remove_column :event_types, :photo_file_name
  end
end
