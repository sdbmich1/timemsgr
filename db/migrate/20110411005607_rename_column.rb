class RenameColumn < ActiveRecord::Migration
  def self.up
   	 rename_column :affiliations, :type, :affiliation_type

  end

  def self.down
  end
end
