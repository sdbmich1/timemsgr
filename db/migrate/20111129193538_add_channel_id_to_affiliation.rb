class AddChannelIdToAffiliation < ActiveRecord::Migration
  def self.up
    add_column :affiliations, :channelID, :string
		add_index :affiliations, :channelID
  end

  def self.down
		remove_index :affiliations, :channelID
    remove_column :affiliations, :channelID
  end
end
