Timemsgr::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  # config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  
  # set mailer host
  config.action_mailer.default_url_options = { :host => 'Starfleet5152V2.kitsus.rbca.net' }
  config.action_mailer.asset_host = "Starfleet5152V2.kitsus.rbca.net"
  
  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
    
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

