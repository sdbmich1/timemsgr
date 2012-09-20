    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.smtp_settings = {  
      :address              => "mail.rbca.net",  
      :port                 => 25,  
      :domain               => "kitsus.rbca.net",  
      :user_name            => nil,  
      :password             => nil,  
      :authentication       => nil,  
      :enable_starttls_auto => true,
      :openssl_verify_mode  => 'none'  
    }  
    
	ActionMailer::Base.default_url_options[:host] = "Starfleet5152V2.kitsus.rbca.net" 
