class Lifeeventtype < ActiveRecord::Migration
  def self.up
    rename_column :event_types, :name, :Description
  end

  def self.down
    rename_column :event_types, :Description, :name

  end
end
