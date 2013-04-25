# Be sure to restart your server when you modify this file.
require 'action_dispatch/middleware/session/dalli_store'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
#Timemsgr::Application.config.session_store :cookie_store, :key => '_timemsgr_session'
Timemsgr::Application.config.session_store :active_record_store
  
memcached_config = YAML.load_file(File.join(Rails.root, 'config', 'memcached.yml'))  
Rails.application.config.session_store :dalli_store,
  :memcache_server => memcached_config[Rails.env],
  :namespace => 'sessions',
  :key => '_session',
  :expire_after => 15.minutes
