class CreateCalendars < ActiveRecord::Migration
  def self.up
    create_table :calendars do |t|
      t.string :name
      t.string :type
      t.string :title
      t.string :template
      t.integer :template_id
      t.date :start_date
      t.date :end_date
      t.integer :location_id

      t.timestamps
    end
    
    add_index :calendars, :location_id
  end

  def self.down
    drop_table :calendars
  end
end
