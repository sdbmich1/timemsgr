class EventObserver < ActiveRecord::Observer
  include ProcessNotice, Rewards
  observe :event, :private_event, :scheduled_event, :life_event
  
  def after_create(model)
    # clear cache
    Event.delete_cached
    
    # send notice as needed
    process_notice(model, 'new') unless model.class.to_s == 'ScheduledEvent'
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
