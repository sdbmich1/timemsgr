class AddFldsToFrequencies < ActiveRecord::Migration
  def self.up
    add_column :frequencies, :status, :string
    add_column :frequencies, :sortkey, :integer
    add_column :frequencies, :hide, :string
  end

  def self.down
    remove_column :frequencies, :hide
    remove_column :frequencies, :sortkey
    remove_column :frequencies, :status
  end
end
