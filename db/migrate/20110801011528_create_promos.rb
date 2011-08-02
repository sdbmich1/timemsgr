class CreatePromos < ActiveRecord::Migration
  def self.up
    create_table :promos do |t|
      t.string :speaker
      t.string :bbody

      t.timestamps
    end
  end

  def self.down
    drop_table :promos
  end
end
