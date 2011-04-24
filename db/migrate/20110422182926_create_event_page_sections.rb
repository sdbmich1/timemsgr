class CreateEventPageSections < ActiveRecord::Migration
  def self.up
    create_table :event_page_sections do |t|
      t.string :event_type
      t.string :title
      t.integer :rank
      t.string :visible

      t.timestamps
    end
		add_index :event_page_sections, [:event_type], :name => "event_type_idx", :unique => true
  end

  def self.down
		remove_index :event_page_sections, :name => :event_type_idx
    drop_table :event_page_sections
  end
end
