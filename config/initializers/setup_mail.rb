    ActionMailer::Base.smtp_settings = {  
      :address              => "Starfleet3052V1@kitsus.rbca.net",  
      :port                 => 25,  
      :domain               => "kitsus.rbca.net",  
      :authentication       => nil,  
      :enable_starttls_auto => true  
    }  
    
	ActionMailer::Base.default_url_options[:host] = "150.150.2.25" 
