class AddAttachmentPhotoToUserPhoto < ActiveRecord::Migration
  def self.up
    add_column :user_photos, :photo_file_name, :string
    add_column :user_photos, :photo_content_type, :string
    add_column :user_photos, :photo_file_size, :integer
    add_column :user_photos, :photo_updated_at, :datetime
  end

  def self.down
    remove_column :user_photos, :photo_file_name
    remove_column :user_photos, :photo_content_type
    remove_column :user_photos, :photo_file_size
    remove_column :user_photos, :photo_updated_at
  end
end
