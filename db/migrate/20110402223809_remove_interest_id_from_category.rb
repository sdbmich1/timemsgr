class RemoveInterestIdFromCategory < ActiveRecord::Migration
  def self.up
    remove_column :categories, :interest_id
  end

  def self.down
    add_column :categories, :interest_id, :integer
  end
end
