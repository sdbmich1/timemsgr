class CreateInterestsUsers < ActiveRecord::Migration
  def self.up
    create_table :interests_users, :id => false do |t|
      t.integer :user_id
      t.integer :interest_id

      t.timestamps
    end
    
    # add index
    add_index :interests_users, [ :user_id, :interest_id ], :unique => true
  end

  def self.down
    drop_table :interests_users
  end
end
