require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do  
      provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :domain => 'gmail.com'
      provider :twitter, 's3dXXXXXXXX', 'lR23XXXXXXXXXXXXXXXXXX'  
      provider :open_id, OpenID::Store::Filesystem.new('/tmp') #, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end