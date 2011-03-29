class AddInterestIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :interest_id, :integer
  end

  def self.down
    remove_column :users, :interest_id
  end
end
