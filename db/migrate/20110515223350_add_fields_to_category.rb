class AddFieldsToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :hide, :string
    add_column :categories, :status, :string
    add_column :categories, :sortkey, :integer
  end

  def self.down
    remove_column :categories, :sortkey
    remove_column :categories, :status
    remove_column :categories, :hide
  end
end
