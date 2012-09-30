class ProcessReoccurrence
  
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
    rc.each do |dte| 
      new_event = model.clone
      new_event.eventstartdate = new_event.eventenddate = dte
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