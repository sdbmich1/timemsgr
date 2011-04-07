class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :channel_id

      t.timestamps
    end
    
    # add index
    add_index :subscriptions, [ :user_id, :channel_id ], :unique => true
  end

  def self.down
    drop_table :subscriptions
  end
end
