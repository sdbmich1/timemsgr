class CreateTimeRanges < ActiveRecord::Migration
  def self.up
    create_table :time_ranges do |t|
      t.string :description
      t.string :hide
      t.integer :numdays
      t.integer :sortkey

      t.timestamps
    end
  end

  def self.down
    drop_table :time_ranges
  end
end
