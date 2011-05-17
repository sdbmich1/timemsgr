class AddStatusToInterest < ActiveRecord::Migration
  def self.up
    add_column :interests, :status, :string
    add_column :interests, :hide, :string
  end

  def self.down
    remove_column :interests, :hide
    remove_column :interests, :status
  end
end
