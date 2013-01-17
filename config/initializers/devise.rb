Devise.setup do |config|
  # ==> Mailer Configuration
  config.mailer_sender = "koncierge@rbca.net"

  # ==> ORM configuration
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  config.authentication_keys = [ :login ]

  # Tell if authentication through HTTP Basic Auth is enabled. False by default.
  config.http_authenticatable = true

  # Set this to true to use Basic Auth for AJAX requests.  True by default.
  config.http_authenticatable_on_xhr = false

  # For bcrypt, this is the cost for hashing the password and defaults to 10. 
  config.stretches = 10

  # Define which will be the encryption algorithm.
  config.encryptor = :bcrypt

  # Setup a pepper to generate the encrypted password.
  config.pepper = "5603cc6cd65547855d84186be7acaa72c44e82e23ac14aa92a0120807c91bc35a11c9521c1b4e16546edfbe7e193f4cf3b774da81bdd29e5640ba6aa2ec3c8a2"

  # Range for password length
  config.password_length = 6..20

  # Regex to use to validate the email address
  config.email_regexp = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i

  # ==> Configuration for :timeoutable
  config.timeout_in = Rails.env.development? ? 120.minutes : 7.days

  # ==> Navigation configuration
  config.navigational_formats = [:"*/*", "*/*", :html, :mobile]

  # ==> OAuth configuration
  require "omniauth-facebook"
  require 'openid/store/filesystem'
  API_KEYS = YAML::load_file("#{Rails.root}/config/api_keys.yml")[Rails.env]
  #config.omniauth :facebook, API_KEYS['facebook']['api_key'], API_KEYS['facebook']['api_secret'], { :client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}} }
  config.omniauth :twitter , API_KEYS['twitter']['api_key'], API_KEYS['twitter']['api_secret']
  config.omniauth :open_id, :store => OpenID::Store::Filesystem.new('/tmp'), :require => 'omniauth-openid'      
end
