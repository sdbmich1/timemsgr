class EventSweeper < ActionController::Caching::Sweeper
  observe Event, PrivateEvent # This sweeper is going to keep an eye on the event model
 
  # If our sweeper detects that a event was created call this
  def after_create(event)
    expire_cache_for(event)
  end
 
  # If our sweeper detects that a event was updated call this
  def after_update(event)
    expire_cache_for(event)
  end
 
  # If our sweeper detects that a event was deleted call this
  def after_destroy(event)
    expire_cache_for(event)
  end
 
  private
  
  def expire_cache_for(event)
    
    # clear cache
    Event.delete_cached

    # Expire a fragment
    expire_fragment('schedule')
  end
end