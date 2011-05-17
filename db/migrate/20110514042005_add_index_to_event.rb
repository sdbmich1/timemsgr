class AddIndexToEvent < ActiveRecord::Migration
  def self.up
		add_index :events, :end_date
  end

  def self.down
		remove_index :events, :end_date
  end
end
