class AddStatusToChannel < ActiveRecord::Migration
  def self.up
    add_column :channels, :status, :string
    add_column :channels, :scope, :string
  end

  def self.down
    remove_column :channels, :scope
    remove_column :channels, :status
  end
end
