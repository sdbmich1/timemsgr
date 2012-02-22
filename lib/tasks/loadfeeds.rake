require "open-uri"
require "nokogiri"
require 'json'

# tasks
namespace :loader do
  desc "Load database with data from 3rd party data feeds"
  task :read_sf_feeds => :environment do
    load_sf_feeds 'c:/RoRDev/SQL/SFChronicleFeed020612.txt', 'San Francisco', -8
  end 
end

def load_sf_feeds(*args)
  feed = ImportFeed.new
  feed.read_feeds *args
end