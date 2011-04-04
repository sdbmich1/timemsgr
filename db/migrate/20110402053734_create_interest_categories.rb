class CreateInterestCategories < ActiveRecord::Migration
  def self.up
    create_table :interest_categories, :id => false do |t|
      t.integer :interest_id
      t.integer :category_id

      t.timestamps
    end
    add_index :interest_categories, [ :interest_id, :category_id ] 
  end

  def self.down
    drop_table :interest_categories
  end
end
