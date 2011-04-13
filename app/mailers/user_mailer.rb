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
  
  def invite_friends(arg)
    @associate = arg
    @user = @associate.user
    @url  = root_url # "http://localhost:3000/sign_up"
    
    attachments.inline['rails.png'] = File.read File.join(Rails.root, 'public/images/rails.png')
#    attachments.inline['sociable-logo.png'] = File.read File.join(Rails.root, 'public/images/sociable-logo.png')

    @css = File.read(File.join(Rails.root, 'public', 'stylesheets', 'custom.css')).gsub(/\/images\/([a-zA-Z\-\_]+\.png)/) do |match|
      attachments.inline[$1] = File.read File.join(Rails.root, 'public', 'images', $1)
      attachments.inline[$1].url
    end
    
    # send email to each associate
	mail(:to => @associate.email,
        	 	 :subject => "Check out my schedule on TimeMsgr")   
  end
end
