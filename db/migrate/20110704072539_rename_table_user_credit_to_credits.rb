class RenameTableUserCreditToCredits < ActiveRecord::Migration
  def self.up
		rename_table :user_credits, :reward_credits
  end

  def self.down
		rename_table :reward_credits, :user_credits
  end
end
