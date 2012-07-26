class EventObserver < ActiveRecord::Observer
  include ProcessNotice, Rewards
  observe :event, :private_event, :scheduled_event, :life_event
    
  def after_create(model)
    # clear cache
    Event.delete_cached
    
    # send notice as needed
    process_notice(model, 'new') unless model.class.to_s == 'ScheduledEvent'
  end
  
  # add events to schedule as needed for re-occurring events
  def schedule_event(model, sdate, edate, period, freq)
    if sdate <= edate
      new_event = model.clone
      new_event.eventstartdate = new_event.eventenddate = sdate
      new_event.save
      schedule_event(model, sdate+freq.send(period), edate, period)
    end
  end
  
  def after_update(model)
    model.changes.each do |key, item|
      if key_field?(key) 
        process_notice(model, 'update'); break
      end
    end
   end
  
  def after_save(model) 
    save_credits(model.contentsourceID, 'Event', @reward_amt)  # add reward credits to user account
  end
  
  def before_save(model)
    check_reminder model
    @reward_amt = add_credits(model.changes)   
  end
  
  def before_destroy model
    process_notice(model, 'delete') if model.eventenddate.to_date >= Date.today && model.class.to_s != 'ScheduledEvent'
  end
  
  private

  def set_reminder model
    rm = Reminder.find_by_eventID model.eventid
    
    if rm
      update_reminder model, rm
    else
      create_reminder model
    end    
  end
  
  def delete_reminder model
    rm = Reminder.find_by_eventID model.eventid
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
    dj = Delayed::Job.enqueue(ReminderJob.new(usr, rm), :run_at => rm.starttime) if usr
    
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
    (%w(eventstartdate eventstarttime remindertype).detect { |x| x == fld})
  end
  
  # check for reminders 
  def check_reminder model
    if model.changes[:remindflg]
      if model.remindflg == 'yes'
        set_reminder model
      else
        delete_reminder model
      end
    else
      update_reminder(model) if model.changes.detect {|key, item| chg_field?(key)}
    end          
  end
 
  def get_code(rtype)
    ReoccurenceType.get_code rtype
  end
  
  def get_freq(rtype)
    Frequency.get_code rtype
  end
    
end
