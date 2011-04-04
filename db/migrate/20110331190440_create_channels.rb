class CreateChannels < ActiveRecord::Migration
  def self.up
    create_table :channels do |t|
      t.string :name
      t.string :title
      t.string :type
      t.string :class
      t.integer :location_id
      t.integer :interest_id

      t.timestamps
    end
  end

  def self.down
    drop_table :channels
  end
end
