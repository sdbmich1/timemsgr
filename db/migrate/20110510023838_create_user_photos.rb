class CreateUserPhotos < ActiveRecord::Migration
  def self.up
    create_table :user_photos do |t|
      t.integer :user_id
      t.string :description

      t.timestamps
    end
    
		add_index :user_photos, :user_id
  end

  def self.down
		remove_index :user_photos, :user_id
    drop_table :user_photos
  end
end
