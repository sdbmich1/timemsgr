class CreatePrivateEventTypes < ActiveRecord::Migration
  def self.up
    create_table :private_event_types do |t|
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :private_event_types
  end
end
