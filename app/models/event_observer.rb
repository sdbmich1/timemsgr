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

  def set_reminder model
    rm = Reminder.find_or_initialize_by_eventID model.eventid
    rm.sourceID, rm.SubscriberID, rm.reminder_name, rm.remindertext, rm.localGMToffset = model.ssid, model.cid, model.event_name, model.bbody[0..249], model.localGMToffset
    rm.reminder_type = ReminderType.get_description model.remindertype rescue nil
    rm.startdate = rm.eventstartdate = model.eventstartdate
    rm.starttime = rm.endtime = rm.set_start_time(model.eventstartdate, model.eventstarttime)
    debugger
    # queue reminder job
    if rm.save
      usr = User.get_user model.cid
      Delayed::Job.enqueue(ReminderJob.new(usr, rm)) if usr
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
    # check for reminders  
    set_reminder model if model.remindflg == 'yes'  

    # add reward credits to user account
    save_credits(model.contentsourceID, 'Event', @reward_amt)
  end
  
  def before_save(model)
    @reward_amt = add_credits(model.changes)   
  end
  
  private
 
  def get_code(rtype)
    ReoccurenceType.get_code rtype
  end
  
  def get_freq(rtype)
    Frequency.get_code rtype
  end
    
end
