class CreateWirelessProviders < ActiveRecord::Migration
  def self.up
    create_table :wireless_providers do |t|
      t.string :code
      t.string :description
      t.string :email
      t.string :status
      t.string :hide
      t.integer :sortkey

      t.timestamps
    end
  end

  def self.down
    drop_table :wireless_providers
  end
end
