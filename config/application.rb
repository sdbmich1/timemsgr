require File.expand_path('../boot', __FILE__)
require 'rails/all'
require 'exception_notifier'
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Timemsgr
  class Application < Rails::Application
     # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths << "#{config.root}/lib"

    # Activate observers that should always be running.
    config.active_record.observers = :user_observer, :affiliation_observer, :notification_observer, :event_observer, 
          :relationship_observer, :reminder_observer, :host_profile_observer
    
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    # add google analytics
    config.middleware.use("Rack::GoogleAnalytics", :web_property_id => "UA-28841665-1") if Rails.env.production?
    
    # exception notification
    if Rails.env.production?
      config.middleware.use ExceptionNotifier,
        :email_prefix => "Koncierge: ",
        :sender_address => %{"Koncierge Admin" <koncierge@rbca.net>},
        :exception_recipients => %w{sdbmich1@gmail.com}
    end  
  end
end