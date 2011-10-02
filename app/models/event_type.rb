class EventType < ActiveRecord::Base
  default_scope :order => 'sortkey ASC'
    
  def self.get_tsd_event_types
    find_by_sql(["SELECT code FROM `kitstsddb`.event_types"])
  end
    
  def self.get_life_event_types
    LifeEventType.all
  end  
end
