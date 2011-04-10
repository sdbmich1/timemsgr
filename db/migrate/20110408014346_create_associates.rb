class CreateAssociates < ActiveRecord::Migration
  def self.up
    create_table :associates do |t|
      t.string :name
      t.string :email
      t.integer :user_id
      
      t.timestamps
    end
    
    add_index :associates, :user_id
  end

  def self.down
    drop_table :associates
  end
end
