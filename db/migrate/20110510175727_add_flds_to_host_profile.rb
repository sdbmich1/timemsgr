class AddFldsToHostProfile < ActiveRecord::Migration
  def self.up
    add_column :host_profiles, :country, :string
    add_column :host_profiles, :company, :string
    add_column :host_profiles, :title, :string
    add_column :host_profiles, :hide, :string
    add_column :host_profiles, :status, :string
    add_column :host_profiles, :ethnicity, :string
    add_column :host_profiles, :nationality, :string
    add_column :host_profiles, :industry, :string
  end

  def self.down
    remove_column :host_profiles, :industry
    remove_column :host_profiles, :nationality
    remove_column :host_profiles, :ethnicity
    remove_column :host_profiles, :status
    remove_column :host_profiles, :hide
    remove_column :host_profiles, :title
    remove_column :host_profiles, :company
    remove_column :host_profiles, :country
  end
end
