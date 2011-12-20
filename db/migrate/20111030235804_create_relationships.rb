class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships, :force => true do |t|
      t.integer :user_id
      t.integer :tracker_id
      t.string :rel_type
      t.string :status

      t.timestamps
    end
    add_index :relationships, :user_id
    add_index :relationships, :tracker_id
    add_index :relationships, [:user_id, :tracker_id], :unique => true
  end

  def self.down
    drop_table :relationships
  end
end
