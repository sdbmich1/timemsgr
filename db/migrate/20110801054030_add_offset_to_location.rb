class AddOffsetToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :localGMToffset, :float
  end

  def self.down
    remove_column :locations, :localGMToffset
  end
end
