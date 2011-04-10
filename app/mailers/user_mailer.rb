class UserMailer < ActionMailer::Base
  default :from => "webmaster@timemsgr.com"
  
  def welcome_email(user)
    @user = user
    @url  = "http://localhost:3000/login"
    mail(:to => @user.email,
         :subject => "Welcome to TimeMsgr") do |format|
      format.html
      format.text
    end
  end
  
  def invite_friends(user)
    @user = user
    @associate = @user.associates
    @url  = "http://localhost:3000/sign_up"
    
    # send email to each associate
    @associate.each do |associate|
#    	if !associate.empty?
    		mail(:to => associate.email,
        	 	 :subject => "Check out my schedule on TimeMsgr")   
 #       end 	
    end
  end
end
