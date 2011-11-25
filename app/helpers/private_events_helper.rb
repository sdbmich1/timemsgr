require "simple_time_select"
module PrivateEventsHelper
  
  def default_time(val)
    Time.now.change(:hour => Time.now.hour+val)
  end

end
