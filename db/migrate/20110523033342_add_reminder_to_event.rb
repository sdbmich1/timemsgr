class AddReminderToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :reminder, :integer
    add_column :events, :remind_method, :string
  end

  def self.down
    remove_column :events, :remind_method
    remove_column :events, :reminder
  end
end
