class AddCversionToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :cversion, :string
    add_column :events, :post_date, :date
    
    add_index :events, :cversion
  end

  def self.down
    remove_column :events, :cversion
  end
end
