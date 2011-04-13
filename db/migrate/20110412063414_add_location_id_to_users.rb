class AddLocationIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :location_id, :integer
    
    add_index :users, :location_id
  end

  def self.down
    remove_column :users, :location_id
  end
end
