class CreateInterestsCategoriesUsers < ActiveRecord::Migration
  def self.up
    create_table :interests_categories_users, :id => false do |t|
      t.integer :user_id
      t.integer :interest_id
      t.integer :category_id

      t.timestamps
    end
    
    # add index
 #   add_index :ic_users, [ :user_id, :interest_id, :category_id ], :unique => true
  end

  def self.down
    drop_table :interests_categories_users
  end
end
