class CreatePromotions < ActiveRecord::Migration
  def self.up
    create_table :promotions do |t|
      t.string :name
      t.string :promo_type
      t.date :start_date
      t.time :start_time
      t.date :end_date
      t.time :end_time
      t.integer :sponsor_id
      t.float :promo_fee
      t.string :promo_descr

      t.timestamps
    end
  end

  def self.down
    drop_table :promotions
  end
end
