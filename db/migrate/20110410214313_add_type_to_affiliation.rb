class AddTypeToAffiliation < ActiveRecord::Migration
  def self.up
    add_column :affiliations, :type, :string
    
    add_index :affiliations, :user_id
  end

  def self.down
    remove_column :affiliations, :type
  end
end
