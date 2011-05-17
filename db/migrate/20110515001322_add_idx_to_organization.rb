class AddIdxToOrganization < ActiveRecord::Migration
  def self.up
		add_index :organizations, :name
  end

  def self.down
		remove_index :organizations, :name
  end
end
