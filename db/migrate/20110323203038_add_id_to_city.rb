class AddIdToCity < ActiveRecord::Migration
  def self.up
    add_column :cities, :city_id, :integer
  end

  def self.down
    remove_column :cities, :city_id
  end
end
