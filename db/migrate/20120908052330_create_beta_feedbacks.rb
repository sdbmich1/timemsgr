class CreateBetaFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :beta_feedbacks do |t|
      t.string :name
      t.integer :rating1
      t.text :comment1
      t.integer :rating2
      t.text :comment2
      t.integer :rating3
      t.text :comment3
      t.integer :rating4
      t.text :comment4
      t.integer :rating5
      t.text :comment5
      t.integer :rating6
      t.text :comment6
      t.integer :rating7
      t.text :comment7
      t.integer :rating8
      t.text :comment8
      t.integer :rating9
      t.text :comment9
      t.integer :rating10
      t.text :comment10
      t.integer :rating11
      t.text :comment11
      t.integer :rating12
      t.text :comment12 
      t.integer :rating13
      t.text :comment13
      t.integer :rating14
      t.text :comment14
      t.integer :rating15
      t.text :comment15
      t.integer :rating16
      t.text :comment16 
      t.integer :rating17
      t.text :comment17
      t.integer :rating18
      t.text :comment18
      t.integer :rating19
      t.text :comment19
      t.integer :rating20
      t.text :comment20                
      t.timestamps
    end
  end

  def self.down
    drop_table :beta_feedbacks
  end
end
