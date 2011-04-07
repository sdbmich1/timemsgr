class AddFldsToChannels < ActiveRecord::Migration
  def self.up
    add_column :channels, :start_date, :date
    add_column :channels, :end_date, :date
    add_column :channels, :start_time, :time
    add_column :channels, :end_time, :time
    add_column :channels, :post_date, :date
    add_column :channels, :expiration_date, :date
    add_column :channels, :author, :string
    add_column :channels, :topic, :string
    add_column :channels, :calender_id, :integer
  end

  def self.down
    remove_column :channels, :calender_id
    remove_column :channels, :topic
    remove_column :channels, :author
    remove_column :channels, :expiration_date
    remove_column :channels, :post_date
    remove_column :channels, :end_time
    remove_column :channels, :start_time
    remove_column :channels, :end_date
    remove_column :channels, :start_date
  end
end
