class AddFldsToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :address, :string
    add_column :events, :city, :string
    add_column :events, :state, :string
    add_column :events, :postalcode, :integer
    add_column :events, :other_details, :string
    add_column :events, :overview, :string
  end

  def self.down
    remove_column :events, :overview
    remove_column :events, :other_details
    remove_column :events, :postalcode
    remove_column :events, :state
    remove_column :events, :city
    remove_column :events, :address
  end
end
