class EventObserver < ActiveRecord::Observer
  require 'recurrence'
  include ProcessNotice, Rewards, UserInfo
  observe :event, :private_event, :scheduled_event, :life_event
    
  def after_create(model)
     # check for social network sharing & publish to user public events via oauth api
    if model.fbCircle == 'yes' && oauth_user
      event = oath_user.event!(:name => model.event_name, :start_time => model.eventstarttime, :end_time => model.eventendtime, 
                :location => model.location, :description => model.bbody)
    end

    # check for reoccuring events
    if model.class.to_s == 'LifeEvent'
      ProcessReoccurrence.new.set_annual_event model if model.annualsamedate == 'yes'
    else
      ProcessReoccurrence.new.set_frequency(model) unless once?(model)
    end
        
    # send notice as needed
    process_notice(model, 'new') unless model.class.to_s == 'ScheduledEvent'
  end
    
  def after_update(model)
    # check for reoccurring events
    recur = ProcessReoccurrence.new
    recur.chk_reoccurring_event(model, 'update') if chg_reoccurring?(model)
    recur.chk_annual_event(model, 'update') if chg_annual?(model)   
    
    # process notification
    process_notice(model, 'update') if model.changes.detect {|key, item| key_field?(key)}
  end
  
  def after_save(model) 
    save_credits(model.contentsourceID, 'Event', @reward_amt) if model.class.to_s == 'PrivateEvent' # add reward credits to user account
  end
  
  def before_save(model)
    ProcessReminder.new.check_reminder model
    @reward_amt = add_credits(model.changes) if model.class.to_s == 'PrivateEvent'  
  end
    
  def before_destroy model
    ProcessReoccurrence.new.remove_future_events(model) if annual_event?(model) || reoccurring_event?(model)
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
 
  def get_code(rtype)
    ReoccurenceType.get_code rtype
  end
  
  def get_freq(rtype)
    Frequency.get_code rtype
  end

  def once? model
    model.reoccurrencetype == 'once' || model.reoccurrencetype.blank?
  end    
end
