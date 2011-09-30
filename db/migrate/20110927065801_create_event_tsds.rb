class CreateEventTsds < ActiveRecord::Migration
  def self.up
    create_table :event_tsds do |t|
      t.string :event_name

      t.timestamps
    end
  end

  def self.down
    drop_table :event_tsds
  end
end
