class AddCodeToChannel < ActiveRecord::Migration
  def self.up
    add_column :channels, :code, :string
  end

  def self.down
    remove_column :channels, :code
  end
end
