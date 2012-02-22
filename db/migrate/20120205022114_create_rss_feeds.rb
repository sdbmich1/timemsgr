class CreateRssFeeds < ActiveRecord::Migration
  def self.up
    create_table :rss_feeds do |t|
      t.string :channelID
      t.string :sourceURL
      t.text :feedURL
      t.string :status
      t.string :hide
      t.integer :sortkey
      t.integer :location_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rss_feeds
  end
end
