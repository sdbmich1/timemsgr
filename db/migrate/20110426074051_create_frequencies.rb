class CreateFrequencies < ActiveRecord::Migration
  def self.up
    create_table :frequencies do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :frequencies
  end
end
