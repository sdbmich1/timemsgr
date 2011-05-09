class AddActivityTypeToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :activity_type, :string
  end

  def self.down
    remove_column :events, :activity_type
  end
end
