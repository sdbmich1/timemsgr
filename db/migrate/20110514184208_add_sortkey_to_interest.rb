class AddSortkeyToInterest < ActiveRecord::Migration
  def self.up
    add_column :interests, :sortkey, :integer
  end

  def self.down
    remove_column :interests, :sortkey
  end
end
