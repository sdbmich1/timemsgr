class AddOrgTypeToOrganization < ActiveRecord::Migration
  def self.up
    add_column :organizations, :org_type, :string
  end

  def self.down
    remove_column :organizations, :org_type
  end
end
