require "open-uri"
require "nokogiri"
require 'json'

# tasks
namespace :loader do
  desc "Load database with data from 3rd party data feeds"
  task :process_feeds => :environment do
    load_sf_feeds '/opt/kits/system/feeds/SFChronicleFeed020612.txt', 'San Francisco', -8
  end 
  
  desc "Load database with data from Stanford feeds"
  task :process_stanford_feeds => :environment do
    load_stanford_feed 'http://events.stanford.edu/xml/rss.xml', 'Stanford', -8
  end

  desc "Load database with data from Stanford athletics feeds"
  task :process_stanford_sports_feeds => :environment do
    load_stanford_data '/opt/kits/system/feeds/StanfordSportsFeed022612.txt', 'Stanford', -8
  end

  desc "Load database with data from MLB feeds"
  task :process_mlb_feeds => :environment do
    load_mlb_feeds '/opt/kits/system/ics/MLBSchedule022512.txt'
  end    
end

def load_sf_feeds(*args)
  feed = ImportNewsFeed.new
  feed.read_feeds *args
end

def load_stanford_feed(*args)
  feed = ImportCollegeFeed.new
  feed.read_stanford_feed *args
end

def load_stanford_data(*args)
  feed = ImportCollegeFeed.new
  feed.read_feeds *args
end

def load_mlb_feeds(*args)
  feed = ImportICSFeed.new
  feed.read_ics_feed *args
end