class AddFieldsToChannel < ActiveRecord::Migration
  def self.up
    add_column :channels, :hide, :string
    add_column :channels, :status, :string
    add_column :channels, :sortkey, :integer
  end

  def self.down
    remove_column :channels, :sortkey
    remove_column :channels, :status
    remove_column :channels, :hide
  end
end
