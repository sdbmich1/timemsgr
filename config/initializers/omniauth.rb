Rails.application.config.middleware.use OmniAuth::Builder do 
  API_KEYS = YAML::load_file("#{Rails.root}/config/api_keys.yml")[Rails.env]
  provider :facebook, API_KEYS['facebook']['api_key'], API_KEYS['facebook']['api_secret'], {:scope => 'email, user_birthday, user_events, user_interests, user_likes', :client_options => {:ssl => {:ca_path => "/etc/ssl/certs"} }} 
  provider :openid, :store => OpenID::Store::Filesystem.new('/tmp')
end