class AddUserIdToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :user_id, :integer
		add_index :events, :user_id
  end

  def self.down
		remove_index :events, :user_id
    remove_column :events, :user_id
  end
end
