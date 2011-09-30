class CreateBrowseMenus < ActiveRecord::Migration
  def self.up
    create_table :browse_menus do |t|
      t.string :name
      t.string :url
      t.string :status
      t.string :hide
      t.integer :sortkey
      t.string :menutype

      t.timestamps
    end
  end

  def self.down
    drop_table :browse_menus
  end
end
