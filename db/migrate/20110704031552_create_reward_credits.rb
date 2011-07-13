class CreateRewardCredits < ActiveRecord::Migration
  def self.up
    create_table :reward_credits do |t|
      t.string :name
      t.string :model_name
      t.integer :credits

      t.timestamps
    end
  end

  def self.down
    drop_table :reward_credits
  end
end
