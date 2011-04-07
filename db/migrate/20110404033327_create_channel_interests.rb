class CreateChannelInterests < ActiveRecord::Migration
  def self.up
    create_table :channel_interests do |t|
      t.integer :channel_id
      t.integer :interest_id

      t.timestamps
    end
  end

  def self.down
    drop_table :channel_interests
  end
end
