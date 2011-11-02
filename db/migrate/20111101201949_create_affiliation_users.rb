class CreateAffiliationUsers < ActiveRecord::Migration
  def self.up
    create_table :affiliation_users do |t|
      t.integer :affiliation_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :affiliation_users
  end
end
