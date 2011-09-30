class CreatePresenters < ActiveRecord::Migration
  def self.up
    create_table :presenters do |t|
      t.string :name
      t.text :bio
      t.string :email
      t.string :fb_address
      t.string :tw_address
      t.string :work_phone
      t.string :mobile_phone
      t.string :title
      t.string :company
      t.integer :session_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :presenters
  end
end
