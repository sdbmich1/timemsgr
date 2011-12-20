class AddIndexOnEventNotice < ActiveRecord::Migration
  def self.up
    add_index :event_notices, [:created_at]
  end

  def self.down
  end
end
