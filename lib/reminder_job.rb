class ReminderJob < Struct.new(:usr, :remind_id)
  include ProcessNotice
  
  def perform
    if run_time?
      send_reminder usr, reminder
    end
  end
  
  def send_reminder usr, reminder
    UserMailer.send_reminder usr.email, reminder, usr
  end
  
  def run_time?  
    Time.now >= reminder.starttime ? true : false
  end
  
  private
    def reminder
      @reminder ||= Reminder.find remind_id
    end
end
