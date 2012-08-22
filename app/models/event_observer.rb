class EventObserver < ActiveRecord::Observer
  require 'recurrence'
  include ProcessNotice, Rewards, UserInfo
  observe :event, :private_event, :scheduled_event, :life_event
    
  def before_create model       
    # check for reoccuring events
    if model.class.to_s == 'LifeEvent'
      set_annual_event model if model.annualsamedate == 'yes'
    else
      set_frequency(model) unless model.reoccurrencetype == 'once'
    end
  end

  def after_create(model)
     # check for social network sharing & publish to user public events via oauth api
    if model.fbCircle == 'yes' && oauth_user
      event = oath_user.event!(:name => model.event_name, :start_time => model.eventstarttime, :end_time => model.eventendtime, :location => model.location,
              :description => model.bbody)
    end

    # clear cache
    Event.delete_cached
    
    # send notice as needed
    process_notice(model, 'new') unless model.class.to_s == 'ScheduledEvent'
  end
    
  def after_update(model)
    # check for reoccurring events
    chk_reoccurring_event(model, 'update') if chg_reoccurring?(model)
    chk_annual_event(model, 'update') if chg_annual?(model)   
    process_notice(model, 'update') if model.changes.detect {|key, item| key_field?(key)}
  end
  
  def after_save(model) 
    save_credits(model.contentsourceID, 'Event', @reward_amt) if model.class.to_s == 'PrivateEvent' # add reward credits to user account
  end
  
  def before_save(model)
    check_reminder model
    @reward_amt = add_credits(model.changes) if model.class.to_s == 'PrivateEvent'  
  end
    
  def before_destroy model
    remove_future_events(model) if annual_event?(model) || reoccurring_event?(model)
    process_notice(model, 'delete') if model.eventenddate.to_date >= Date.today && model.class.to_s != 'ScheduledEvent'
  end
  
  private
  
  def chg_annual? model
    model.class.to_s == 'LifeEvent' && model.changes[:annualsamedate]
  end
  
  def chg_reoccurring? model
    model.class.to_s == 'PrivateEvent' && (model.changes[:reoccurrencetype] || model.changes[:reoccurrenceenddate])
  end
  
  def annual_event? model
    model.class.to_s == 'LifeEvent' && model.annualsamedate == 'yes'
  end
  
  def reoccur_type? model
    model.reoccurrencetype != 'once' && !model.reoccurrencetype.blank?
  end
  
  def reoccurring_event? model
    model.class.to_s == 'PrivateEvent' && reoccur_type?(model)
  end

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
 
  def get_code(rtype)
    ReoccurenceType.get_code rtype
  end
  
  def get_freq(rtype)
    Frequency.get_code rtype
  end
  
  def chk_annual_event model, action
    remove_future_events if action == 'update' 
    set_annual_event model if model.annualsamedate == 'yes'
  end
  
  def chk_reoccurring_event model, action    
    remove_future_events model if action == 'update' # remove existing future events since parent event has changed
    set_frequency model if reoccur_type?(model)
  end
  
  def remove_future_events model    
    elist = PrivateEvent.where('eventid = ? and eventstartdate != ?', model.eventid, model.eventstartdate) if model.class.to_s == 'PrivateEvent'
    elist = LifeEvent.where('eventid = ? and eventstartdate != ?', model.eventid, model.eventstartdate) if model.class.to_s == 'LifeEvent'
    elist.map { |e| e.destroy } if elist
  end
  
  # create array to set up reoccurring events within given timeframe
  def set_frequency model
    case model.reoccurrencetype
    when 'daily-7'
      r = Recurrence.daily(:starts => sdate(model, 1), :until => edate(model))
    when 'daily-6'
      r = Recurrence.weekly(:starts => sdate(model, 1), :on => [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday],  :until => edate(model))
    when 'daily-5'
      r = Recurrence.weekly(:starts => sdate(model, 1), :on => [:monday, :tuesday, :wednesday, :thursday, :friday], :until => edate(model))
    when 'weekly-13'
      r = Recurrence.weekly(:starts => sdate(model, 28), :on => wkday(model), :interval => 4, :until => edate(model))  
    when 'weekly-26'
      r = Recurrence.weekly(:starts => sdate(model, 14), :on => wkday(model), :interval => 2, :until => edate(model))  
    when 'weekly-52'
      r = Recurrence.weekly(:starts => sdate(model, 7), :on => wkday(model), :until => edate(model))  
    when 'monthly-sd'
      r = Recurrence.monthly(:starts => mdate(model, 1), :on => model.eventstartdate.day, :until => edate(model))
    when 'monthly-sw'
      r = Recurrence.new(:starts => mdate(model, 1), :every => :month, :on => week_of_month(model.eventstartdate), :weekday => wkday(model), :until => edate(model))
    when 'monthly-ld'
      r = Recurrence.new(:starts => mdate(model, 1), :every => :month, :on => 31, :until => edate(model))
    when 'monthly-6'
      r = Recurrence.new(:starts => mdate(model, 6), :every => :month, :on => model.eventstartdate.day, :interval => 6, :until => edate(model))
    when 'quarterly-sd'
      r = Recurrence.new(:starts => mdate(model, 3), :every => :month, :on => model.eventstartdate.day, :interval => :quarterly, :until => edate(model))
    when 'quarterly-sw'
      r = Recurrence.new(:starts => mdate(model, 3),:every => :month, :on => week_of_month(model.eventstartdate), :weekday => wkday(model), :interval => :quarterly, :until => edate(model))
    when 'annual'
      r = Recurrence.yearly(:starts => mdate(model, 12), :on => [model.eventstartdate.month, model.eventstartdate.day], :until => edate(model))
    end
    
    # add future events to schedule
    add_future_events r, model
  end
  
  def set_annual_event model
    r = Recurrence.yearly(:starts => mdate(model, 12), :on => [model.eventstartdate.month, model.eventstartdate.day], :repeat => 5) if model.annualsamedate == 'yes'
    add_future_events r, model
  end
  
  # add events to db
  def add_future_events rc, model  
    rc.each do |date| 
      new_event = model.clone
      new_event.eventstartdate = new_event.eventenddate = date
      new_event.eventstarttime, new_event.eventendtime = model.eventstarttime, model.eventendtime       
      new_event.reoccurrencetype, new_event.reoccurrenceenddate = 'once', nil if model.class.to_s == 'PrivateEvent' 
      new_event.annualsamedate = nil if model.class.to_s == 'LifeEvent' 
      new_event.save(:validate=>false) 
    end   
  end
    
  def week_of_month item
    item.to_date.cweek - item.at_beginning_of_month.to_date.cweek
  end
  
  def sdate model, amt
    model.eventstartdate.to_date + amt.days
  end 
  
  def mdate model, amt
    model.eventstartdate.to_date + amt.months
  end 
  
  def edate model
    model.reoccurrenceenddate.to_date
  end
  
  def wkday model
    model.eventstartdate.wday
  end
end
