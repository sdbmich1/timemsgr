class AddNewIdxToEvent < ActiveRecord::Migration
  def self.up
		add_index :events, :start_date
  end

  def self.down
		remove_index :events, :start_date
  end
end
