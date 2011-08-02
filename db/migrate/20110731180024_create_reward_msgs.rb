class CreateRewardMsgs < ActiveRecord::Migration
  def self.up
    create_table :reward_msgs do |t|
      t.string :msg_type
      t.string :description

      t.timestamps
    end
    
		add_index :reward_msgs, :msg_type
  end

  def self.down
		remove_index :reward_msgs, :msg_type
    drop_table :reward_msgs
  end
end
