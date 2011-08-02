class CreateEventTypeImages < ActiveRecord::Migration
  def self.up
    create_table :event_type_images do |t|
      t.string :event_type
      t.string :image_file

      t.timestamps
    end
  end

  def self.down
    drop_table :event_type_images
  end
end
