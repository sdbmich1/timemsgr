class AddColsToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :contact_name, :string
    add_column :events, :website, :string
    add_column :events, :email, :string
    add_column :events, :phone, :string
  end

  def self.down
    remove_column :events, :phone
    remove_column :events, :email
    remove_column :events, :website
    remove_column :events, :contact_name
  end
end
