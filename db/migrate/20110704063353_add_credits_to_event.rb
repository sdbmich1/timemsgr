class AddCreditsToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :credits, :integer
  end

  def self.down
    remove_column :events, :credits
  end
end
