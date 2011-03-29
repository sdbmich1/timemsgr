class RemoveInterestIdFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :interest_id
  end

  def self.down
    add_column :users, :interest_id, :integer
  end
end
