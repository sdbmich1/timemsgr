class RemoveInterestFromInterestsUsers < ActiveRecord::Migration
  def self.up
    remove_column :interests_users, :interest
  end

  def self.down
    add_column :interests_users, :interest, :boolean
  end
end
