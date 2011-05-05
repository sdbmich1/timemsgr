class AddNotifyFlgsToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :family_flg, :boolean
    add_column :events, :friends_flg, :boolean
    add_column :events, :world_flg, :boolean
  end

  def self.down
    remove_column :events, :world_flg
    remove_column :events, :friends_flg
    remove_column :events, :family_flg
  end
end
