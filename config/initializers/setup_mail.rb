    ActionMailer::Base.smtp_settings = {  
      :address              => "smtp.gmail.com",  
      :port                 => 587,  
      :domain               => "buzzhubnetwork.com",  
      :user_name            => "sdbmich1",  
      :password             => "sdb91mse",  
      :authentication       => "plain",  
      :enable_starttls_auto => true  
    }  
    
	ActionMailer::Base.default_url_options[:host] = "localhost:3000" 
