# Use this file to easily define all of your cron jobs.

# set output file location
set :log_path, "~/sites/koncierge/shared/log"
set :output, "#{log_path}/cron_log.log"

# process news feeds - west coast
every "0 0 * * 0,3,5", :roles => [:app] do
  rake "loader:process_sf_feeds", :output => {:error => "#{log_path}/sffeeds_error.log", :standard => "#{log_path}/sffeeds.log"}
  rake "loader:process_sj_feeds", :output => {:error => "#{log_path}/sjfeeds_error.log", :standard => "#{log_path}/sjfeeds.log"}
  rake "loader:process_denver_feeds", :output => {:error => "#{log_path}/denfeeds_error.log", :standard => "#{log_path}/denfeeds.log"}
  rake "loader:process_oc_feeds", :output => {:error => "#{log_path}/ocfeeds_error.log", :standard => "#{log_path}/ocfeeds.log"}
end

# process east coast news feeds
every "0 3 * * 0,3,5", :roles => [:app] do
  rake "loader:process_ny_feeds", :output => {:error => "#{log_path}/nyfeeds_error.log", :standard => "#{log_path}/nyfeeds.log"}
  rake "loader:process_atlanta_feeds", :output => {:error => "#{log_path}/atlfeeds_error.log", :standard => "#{log_path}/atlfeeds.log"}
end

# process college feeds
every "0 2 * * 2,4,6", :roles => [:app] do
  rake "loader:process_stanford_feeds"
  rake "loader:process_sfstate_feeds"
end

