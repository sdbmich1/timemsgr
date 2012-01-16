class AddFldsToFrequencies < ActiveRecord::Migration
  def self.up
    add_column :frequencies, :numdays, :integer
    add_column :frequencies, :status, :string
    add_column :frequencies, :sortkey, :integer
    add_column :frequencies, :hide, :string
    add_column :frequencies, :code, :string
  end

  def self.down
    remove_column :frequencies, :numdays
    remove_column :frequencies, :hide
    remove_column :frequencies, :sortkey
    remove_column :frequencies, :code
    remove_column :frequencies, :status
  end
end
