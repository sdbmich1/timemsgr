class CreateUserPrefs < ActiveRecord::Migration
  def self.up
    create_table :user_prefs do |t|
      t.integer :user_id
      t.string :pref

      t.timestamps
    end
  end

  def self.down
    drop_table :user_prefs
  end
end
