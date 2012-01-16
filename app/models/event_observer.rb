class EventObserver < ActiveRecord::Observer
  include ProcessNotice, Rewards
  observe :event, :private_event, :scheduled_event, :life_event
  
  def after_create(model)
    # clear cache
    Event.delete_cached
    
    # check if event is longer than one day add additional days to schedule
#    if model.eventstartdate < model.eventenddate
#      model.class.to_s == 'PrivateEvent' ? code = get_code(model.reoccurencetype) : code = 'days'
#      model.class.to_s == 'PrivateEvent' ? freq = get_freq(model.reoccurencetype) : freq = 1
#      schedule_event(model, model.eventstartdate.to_date+freq.send(code), model.eventenddate.to_date, code, freq)
#    end
    
    # send notice as needed
    process_notice(model, 'new') unless model.class.to_s == 'ScheduledEvent'
  end
  
  # add events to schedule as needed for reoccuring events
  def schedule_event(model, sdate, edate, period, freq)
    if sdate <= edate
      new_event = model.clone
      new_event.eventstartdate = new_event.eventenddate = sdate
      new_event.save
      schedule_event(model, sdate+freq.send(period), edate, period)
    end
  end
  
  def get_code(rtype)
    Frequency.get_code rtype
  end
  
  def after_update(model)
    model.changes.each do |key, item|
      if key_field?(key) 
        process_notice(model, 'update'); break
      end
    end
  end
  
  def after_save(model)
    save_credits(model.contentsourceID, 'Event', @reward_amt)
  end
  
  def before_save(model)
    @reward_amt = add_credits(model.changes)   
  end
  
end
