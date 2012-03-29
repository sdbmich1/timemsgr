Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :facebook, '131627943626812', '440e7e13fcf9ccc418d727e9b2f59b79', {:scope => 'email, user_birthday, user_events, user_interests', :client_options => {:ssl => {:ca_file => Rails.root.join('/lib/assets/ca-bundle.crt').to_s} }} 
  provider :openid, :store => OpenID::Store::Filesystem.new('/tmp')
#  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :domain => 'gmail.com'
#  provider :open_id, OpenID::Store::Filesystem.new('/tmp') #, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end