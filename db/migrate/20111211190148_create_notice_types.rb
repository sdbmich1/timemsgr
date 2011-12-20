class CreateNoticeTypes < ActiveRecord::Migration
  def self.up
    create_table :notice_types do |t|
      t.string :code
      t.string :event_type
      t.string :description
      t.string :hide
      t.integer :sortkey
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :notice_types
  end
end
