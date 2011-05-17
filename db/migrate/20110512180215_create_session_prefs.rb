class CreateSessionPrefs < ActiveRecord::Migration
  def self.up
    create_table :session_prefs do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :session_prefs
  end
end
