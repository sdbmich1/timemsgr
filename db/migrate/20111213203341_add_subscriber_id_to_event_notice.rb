class AddSubscriberIdToEventNotice < ActiveRecord::Migration
  def self.up
    add_column :event_notices, :subscriberID, :string
  end

  def self.down
    remove_column :event_notices, :subscriberID
  end
end
