class UserMailer < ActionMailer::Base
  default :from => "koncierge@rbca.net"
    
  def welcome_email(user)
    @user = user
    @title = 'Koncierge'
    @url  = root_url + "sign_in"
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Welcome to #{@title}, #{user.first_name}!") 
  end

  def send_notice(email, notice, usr)
    @url  = root_url + "sign_up"
    @notice = notice; @user = usr
    mail(:to => "#{email}", :subject => "#{notice.title}: #{notice.start_date} @ #{notice.start_time} - #{notice.end_time}")     
  end
  
  def send_request(email, notice, usr)
    @url  = root_url + "sign_up"
    @notice = notice; @user = usr
    mail(:to => "#{email}", :subject => "#{notice.title}: #{notice.message}")        
  end
  
  def send_reminder email, reminder, usr
    @tz = GmtTimezone.get_timezone reminder.localGMToffset
    @reminder = reminder; @user = usr
    mail(:to => "#{email}", :subject => "Reminder: #{reminder.reminder_name} @ #{reminder.starttime} - #{reminder.endtime} ")        
  end

  def send_sms_reminder email, reminder, usr
    @tz = GmtTimezone.get_timezone reminder.localGMToffset
    @reminder = reminder; @user = usr
    mail(:to => "#{email}", :subject => "Reminder: #{reminder.reminder_name} @ #{reminder.starttime} - #{reminder.endtime} ")        
  end
 
end
