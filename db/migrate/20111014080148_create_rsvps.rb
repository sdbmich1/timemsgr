class CreateRSVPs < ActiveRecord::Migration
  def self.up
    create_table :rsvps do |t|
      t.string :eventid
      t.string :subscriptionsourceID
      t.timestamps
    end
  end

  def self.down
    drop_table :rsvps
  end
end
