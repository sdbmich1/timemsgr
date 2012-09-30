class ProcessReminder
  
  def set_reminder model
    rm = Reminder.find_by_eventID_and_eventstartdate model.eventid, model.eventstartdate
    rm ? update_reminder(model, rm) : create_reminder(model)
  end
  
  def delete_reminder model
    rm = Reminder.find_by_eventID_and_eventstartdate model.eventid, model.eventstartdate
    rm.destroy if rm
  end
  
  def set_times rm, model
    rm.eventstartdate = model.eventstartdate
    rm.startdate = rm.starttime = rm.endtime = rm.set_start_time(model.eventstartdate, model.eventstarttime)

    #set reminder date & time
    model.remindstartdate = model.remindenddate = model.remindstarttime = model.remindendtime = rm.startdate
  end
  
  def create_reminder model
    rm = Reminder.new
    rm.eventID, rm.sourceID, rm.SubscriberID, rm.reminder_name, rm.remindertext, rm.localGMToffset = model.eventid, model.ssid, model.cid, model.event_name, model.bbody[0..249], model.localGMToffset
    rm.reminder_type = ReminderType.get_description model.remindertype rescue nil
    
    # set reminder times
    set_times rm, model
    
    # queue reminder job 
    usr = User.get_user model.cid         
    dj = Delayed::Job.enqueue(ReminderJob.new(usr, rm.eventID), :run_at => rm.starttime) if usr
    
    if rm
      rm.delayed_job_id = dj.id if dj
      rm.save    
    end
  end
  
  def update_reminder(*args)
    model = args[0]    
    rm = args[1] || Reminder.find_by_eventID(model.eventid)
    
    if rm          
      set_times rm, model  # reset start times      
      rm.reminder_type = ReminderType.get_description model.remindertype rescue nil   # set reminder type 
      rm.save
    end
  end  
  
  def chg_field?(fld)
    (%w(eventstartdate eventstarttime remindertype).detect { |x| x == fld })
  end
  
  # check for reminders 
  def check_reminder model
    if model.changes[:remindflg]
      model.remindflg == 'yes' ? set_reminder(model) : delete_reminder(model)
    else
      update_reminder(model) if model.changes.detect {|key, item| chg_field?(key)}
    end          
  end
end 
