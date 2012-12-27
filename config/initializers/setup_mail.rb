ActionMailer::Base.delivery_method = :smtp

# toggle based on Rails environment
if Rails.env.development?
  smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => "gmail.com",
      :user_name            => "sdbmich1",
      :password             => "sdb91mse",
      :authentication       => "plain",
      :enable_starttls_auto => true
    }
  host_url = "localhost:3000"
else
  smtp_settings = {  
      :address              => "mail.rbca.net",  
      :port                 => 25,  
      :domain               => "kitsus.rbca.net",  
      :user_name            => nil,  
      :password             => nil,  
      :authentication       => nil,  
      :enable_starttls_auto => true,
      :openssl_verify_mode  => 'none'  
    } 
  host_url = "Starfleet5152V2.kitsus.rbca.net" 
end

# set vars    
ActionMailer::Base.smtp_settings = smtp_settings
ActionMailer::Base.default_url_options[:host] = host_url
