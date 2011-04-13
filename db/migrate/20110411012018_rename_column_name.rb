class RenameColumnName < ActiveRecord::Migration
  def self.up
  	  rename_column :affiliation_types, :type, :name

  end

  def self.down
  end
end
