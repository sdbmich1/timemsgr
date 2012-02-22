require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do  
      provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :domain => 'gmail.com'
      provider :facebook, '131627943626812', '440e7e13fcf9ccc418d727e9b2f59b79'  
      provider :open_id, OpenID::Store::Filesystem.new('/tmp') #, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end