class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.integer :user_id
      t.integer :session_pref_id

      t.timestamps
    end
		add_index :settings, :user_id
		add_index :settings, :session_pref_id
  end

  def self.down
		remove_index :settings, :session_pref_id
		remove_index :settings, :user_id
    drop_table :settings
  end
end
