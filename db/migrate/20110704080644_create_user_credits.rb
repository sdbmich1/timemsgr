class CreateUserCredits < ActiveRecord::Migration
  def self.up
    create_table :user_credits do |t|
      t.integer :user_id
      t.integer :event_id
      t.string  :context
      t.integer :credits

      t.timestamps
    end

		add_index :user_credits, :user_id
  end

  def self.down
		remove_index :user_credits, :user_id
    drop_table :user_credits
  end
end
