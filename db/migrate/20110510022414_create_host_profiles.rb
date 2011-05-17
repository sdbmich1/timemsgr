class CreateHostProfiles < ActiveRecord::Migration
  def self.up
    create_table :host_profiles do |t|
      t.integer :user_id
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.integer :postalcode
      t.string :home_phone
      t.string :work_phone
      t.string :cell_phone

      t.timestamps
    end
    
		add_index :host_profiles, :user_id
  end

  def self.down
		remove_index :host_profiles, :user_id
    drop_table :host_profiles
  end
end
