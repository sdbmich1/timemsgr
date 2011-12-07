require "simple_time_select"
module PrivateEventsHelper
  
  def default_time(val)
    Time.now.change(:hour => Time.now.hour+val)
  end
  
  def get_label_type(cntr)
    cntr == 'private_events' ? "private_event" : cntr == 'life_events' ? "life_event" : "scheduled_event"
  end

end
