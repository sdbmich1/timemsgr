require 'exception_notifier'
Timemsgr::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = true

  # set mailer host
  config.action_mailer.default_url_options = { :host => 'Starfleet5152V2.kitsus.rbca.net' }
  config.action_mailer.asset_host = "Starfleet5152V2.kitsus.rbca.net"

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_deliveries = true

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  # added for memcached
  config.cache_store = :dalli_store #, '127.0.0.1', '127.0.0.1:11211', { :namespace => 'koncierge' }
      
  # exception notification
  config.middleware.use ExceptionNotifier,
        :email_prefix => "Koncierge: ",
        :sender_address => %{"Koncierge Admin" <koncierge@rbca.net>},
        :exception_recipients => %w{sdbmich1@gmail.com}
  
  if defined?(PhusionPassenger)
    PhusionPassenger.on_event(:starting_worker_process) do |forked|
      # Reset Rails's object cache
      # Only works with DalliStore
      Rails.cache.reset if forked

      # Reset Rails's session store
      # If you know a cleaner way to find the session store instance, please let me know
      ObjectSpace.each_object(ActionDispatch::Session::DalliStore) { |obj| obj.reset }
    end
  end  
end
