class CreateUserInterests < ActiveRecord::Migration
  def self.up
    create_table :user_interests do |t|
      t.integer :user_id
      t.integer :interest_id

      t.timestamps
    end
    add_index :user_interests, :user_id, :name => "ui_userid_idx"
    add_index :user_interests, :interest_id, :name => "ui_intid_idx"
    add_index :user_interests, [:user_id, :interest_id], :name => "ui_userint_idx"    
  end

  def self.down
    drop_table :user_interests
  end
end
