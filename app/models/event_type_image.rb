class EventTypeImage < ActiveRecord::Base
  
  def self.etype(val)
    where('event_type = ?', val).first
  end
end
