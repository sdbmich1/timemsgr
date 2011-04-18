class DropTableIcUser < ActiveRecord::Migration
  def self.up
  	drop_table :interests_categories_users
  	drop_table :interest_categories
  end

  def self.down
  end
end
