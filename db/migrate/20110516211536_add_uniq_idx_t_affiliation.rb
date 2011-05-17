class AddUniqIdxTAffiliation < ActiveRecord::Migration
  def self.up
		add_index :affiliations, [:user_id, :name], :unique => true
  end

  def self.down
		remove_index :affiliations, :column => [:user_id, :name]
  end
end
