class AddCountryToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :country, :string
  end

  def self.down
    remove_column :events, :country
  end
end
