class AddContentsourceIdToAffiliation < ActiveRecord::Migration
  def self.up
    add_column :affiliations, :contentsourceID, :string
  end

  def self.down
    remove_column :affiliations, :contentsourceID
  end
end
