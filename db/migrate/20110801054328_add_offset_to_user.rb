class AddOffsetToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :localGMToffset, :float
  end

  def self.down
    remove_column :users, :localGMToffset
  end
end
