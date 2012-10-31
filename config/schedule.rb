# Use this file to easily define all of your cron jobs.

# set output file location
set :output, "~/sites/koncierge/shared/log/cron_log.log"

# process news feeds
every :sunday, :tuesday, :thursday, :at => '12:00am', :roles => [:app] do
  rake "loader:process_sf_feeds"
  rake "loader:process_ny_feeds"
  rake "loader:process_atlanta_feeds"
  rake "loader:process_denver_feeds"
  rake "loader:process_sj_feeds"
  rake "loader:process_oc_feeds"
end

# process college feeds
every :sunday, :tuesday, :thursday, :at => '2:00am', :roles => [:app] do
  rake "loader:process_stanford_feeds"
  rake "loader:process_sfstate_feeds"
end

