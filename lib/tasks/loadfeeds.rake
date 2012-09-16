require "open-uri"
require "nokogiri"
require 'json'

# tasks
namespace :loader do
  desc "Load database with data from 3rd party data feeds"
  task :process_news_feeds => :environment do  
    p 'Loading SF Chronicle Feed...'  
    load_news_feeds RAILS_ROOT + '/lib/feeds/SFChronicleFeed020612.txt', 'San Francisco', -8
    p 'Loading SJ Mercury News Feed...'  
    load_news_feeds RAILS_ROOT + '/lib/feeds/SJMercuryNewsFeed020612.txt', 'San Jose', -8
    p 'Loading Atlanta News Feed...'  
    load_news_feeds RAILS_ROOT + '/lib/feeds/AtlantaJournalConstitutionFeed020612.txt', 'Atlanta', -5
    p 'Loading Denver Post News Feed...'  
    load_news_feeds RAILS_ROOT + '/lib/feeds/DenverPostFeed020612.txt', 'Denver', -7
    p 'Loading OC Register News Feed...'  
    load_news_feeds RAILS_ROOT + '/lib/feeds/OCRegisterFeed020612.txt', 'Orange County', -8
    p 'Loading NY Daily News Feed...'  
    load_news_feeds RAILS_ROOT + '/lib/feeds/NYDailyNewsFeed020612.txt', 'New York', -5
  end 
  
  task :process_sf_feeds => :environment do
    p 'Loading SF Chronicle Feed...'  
    load_news_feeds RAILS_ROOT + '/lib/feeds/SFChronicleFeed020612.txt', 'San Francisco', -8
  end
  
  task :process_atlanta_feeds => :environment do
    p 'Loading Atlanta News Feed...'  
    load_news_feeds RAILS_ROOT + '/lib/feeds/AtlantaJournalConstitutionFeed020612.txt', 'Atlanta', -5    
  end
  
  task :process_ny_feeds => :environment do
    p 'Loading NY Daily News Feed...'  
    load_news_feeds RAILS_ROOT + '/lib/feeds/NYDailyNewsFeed020612.txt', 'New York', -5
  end
  
  task :process_sj_feeds => :environment do
    p 'Loading SJ Mercury News Feed...'  
    load_news_feeds RAILS_ROOT + '/lib/feeds/SJMercuryNewsFeed020612.txt', 'San Jose', -8
  end
  
  desc "Load database with data from Stanford feeds"
  task :process_stanford_feeds => :environment do
    p 'Loading Stanford General Events Feed...'  
    load_stanford_feed 'http://events.stanford.edu/xml/rss.xml', 'Stanford', -8
    p 'Loading Stanford Sports Events Feed...'  
    load_stanford_data RAILS_ROOT + '/lib/feeds/StanfordSportsFeed022612.txt', 'Stanford', -8
  end
  
  desc "Load database with data from SF State feeds"
  task :process_sfstate_feeds => :environment do
    p 'Loading SF State General Events Feed...'  
    load_sfstate_feed "http://apps.sfsu.edu/cgi-bin/student/", "webcalendar.htm", "San Francisco State", -8   
    p "Loading SF State Sports Events Feeds..."  
    load_ics_feeds RAILS_ROOT + '/lib/feeds/SFStateSportsFeed022612.txt'
  end  

  desc "Load database with data from MLB feeds"
  task :process_mlb_feeds => :environment do
    load_ics_feeds RAILS_ROOT + '/lib/feeds/MLBScheduleFeed022712.txt'
  end  
  
  desc "Load database with data from NFL feeds"
  task :process_nfl_feeds => :environment do
    load_ics_feeds RAILS_ROOT + '/lib/feeds/NFLScheduleFeed022712.txt'
  end  
  
  desc "Load database with data from pro golf feeds"
  task :process_golf_feeds => :environment do
    load_golf_feeds    
  end  
end

def load_news_feeds(*args)
  feed = ImportNewsFeed.new
  feed.read_feeds(*args)
end

def load_stanford_feed(*args)
  feed = ImportCollegeFeed.new
  feed.read_stanford_feed(*args)
end

def load_stanford_data(*args)
  feed = ImportCollegeFeed.new
  feed.read_feeds(*args)
end

def load_sfstate_feed(*args)
  feed = ImportCollegeFeed.new
  feed.read_sfstate_feed(*args)
end

def load_ics_feeds(*args)
  feed = ImportICSFeed.new
  feed.read_feeds(*args)
end

def load_golf_feeds
  feed = ImportGolfEvent.new
  feed.parse_golf_events 'http://www.pgatour.com/r/schedule/', 'US Professional Golf Association Tour Tournaments', 54, 6, 'PGA:' # pga tour
  feed.parse_golf_events 'http://www.pgatour.com/s/schedule/', 'US Professional Golf Association Seniors Tour Tournaments', 25, 5, 'Golf:' # champions tour
  feed.parse_golf_events 'http://www.pgatour.com/h/schedule/', 'US Professional Golf Association Tour Tournaments',35, 5, 'Golf:' # nationwide tour
  feed.process_lpga_events 'http://www.golfchannel.com/tours/lpga/?t=schedule','US Ladies Professional Golf Association Tour Tournaments', 'LPGA:'  # lpga tour
end