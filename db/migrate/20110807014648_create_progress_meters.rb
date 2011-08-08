class CreateProgressMeters < ActiveRecord::Migration
  def self.up
    create_table :progress_meters do |t|
      t.string :title
      t.integer :maxval
      t.integer :sortkey
      t.string :hide
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :progress_meters
  end
end
