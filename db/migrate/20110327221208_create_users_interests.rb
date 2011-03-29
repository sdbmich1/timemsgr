class CreateUsersInterests < ActiveRecord::Migration
  def self.up
    create_table :users_interests do |t|
      t.integer :user_id
      t.integer :interest_id

      t.timestamps
    end
  end

  def self.down
    drop_table :users_interests
  end
end
