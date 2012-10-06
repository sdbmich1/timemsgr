class ReminderJob < Struct.new(:usr, :remind_id)
  include ProcessNotice
  
  def perform
    send_reminder usr, reminder
#      reminder.delete if reminder #delete reminder
  end
  
  def send_reminder usr, rm
    UserMailer.send_reminder usr.email, rm, usr if usr.email
    UserMailer.send_sms_reminder usr.sms_email, rm, usr if usr.sms_email 
  end
  
  def run_time?  
    Time.now >= reminder.starttime
  end
  
  private
  
  def reminder
    @reminder ||= Reminder.find_by_eventID remind_id
  end
end
