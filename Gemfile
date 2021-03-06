source 'http://rubygems.org'

gem 'rails', '3.0.9'
gem 'rake' #, '0.8.7'

gem 'passenger'

#gem 'sqlite3'
gem 'mysql2', '0.2.6'

gem 'will_paginate', '~> 3.0'
gem 'devise', '1.5.3'

# => add autocomplete search capability
gem 'rails3-jquery-autocomplete'

# install meta-where & search to extend named scopes
gem 'meta_where'
gem 'meta_search'

# install oauth
gem 'omniauth'
#gem "oa-core", "~> 0.3.2"

# add facebook & twitter
gem "omniauth-facebook", '1.4.0'
gem "omniauth-twitter"
gem "omniauth-github"
gem "omniauth-openid"

# facebook graph
gem "fb_graph", '~> 1.8.4' #"~> 2.4.6"

# add form validations 
gem 'client_side_validations'  

# add date validation
gem 'validates_timeliness', '~> 3.0.2'

# add unread 
gem 'unread'

# add forms helper
gem 'formtastic', '~> 1.2.3'

#add mechanize for web crawling
gem "mechanize", "~> 2.3"
 
# add nifty
gem "nifty-generators", :group => :development

# add simple forms
gem 'simple_form'

# add jquery
gem "jquery-rails"

# add gravatar
gem 'gravatar_image_tag', '1.0.0.pre2'

# add paperclip for photos
gem 'paperclip'

# add thinking sphinx
gem 'thinking-sphinx', '2.0.10'

# add google calendar
gem "gcal4ruby"

# add icalendar access
gem 'ics', "~> 0.1"

# add for date syntax
gem "ice_cube", "~> 0.7.8"

#add whenever for cron jobs
gem 'whenever', :require => false

#add timezone
gem 'timezone', "~> 0.1.4"

#add recurrence
gem "recurrence", :require => "recurrence/namespace"

# add geokit
gem 'geokit', "~> 1.6.5"
gem "geokit-rails3", "~> 0.1.5"

gem 'rvm-capistrano'
gem 'nokogiri', ">= 1.4.4.1" #, "<=1.5.0.beta.2" 

group :development, :test do
#  gem 'capybara'
  gem 'spork', '~> 0.9.0.rc'
  gem 'rspec-rails'
  gem "hpricot", "0.8.3", :platform => :mswin
  gem 'mocha'
  gem 'ruby-debug19'
  gem 'ruby_parser'
  gem 'web-app-theme', '>= 0.6.2'
end

group :test do
  gem 'factory_girl_rails' #, '1.0'
  gem 'webrat'
end

# Deploy with Capistrano
 gem 'capistrano'
 
# add caching
gem "dalli"
 
# add asynchronous processing
gem 'delayed_job_active_record'

# data dump utility
gem 'yaml_db'

# rss feed reader
gem "feedzirra", "~> 0.1.1"
 
gem 'faker', '0.3.1'

# for delayed jobs
gem 'daemons'

# add payment gateways
gem 'activemerchant'
gem 'stripe'
 
group :production do
  # handle exceptions
  gem 'exception_notification', :require => 'exception_notifier'
  
  # google analytics
  gem 'rack-google_analytics', :require => "rack/google_analytics"
end 
 