class ReminderJob < Struct.new(:usr, :remind_id)
  include ProcessNotice
  
  def perform
    send_reminder usr, reminder
    reminder.delete if reminder #delete reminder
  end
  
  def send_reminder usr, reminder
    UserMailer.send_reminder usr.email, reminder, usr
  end
  
  def run_time?  
    Time.now >= reminder.starttime
  end
  
  private
  
    def reminder
      @reminder ||= Reminder.find remind_id
    end
end
