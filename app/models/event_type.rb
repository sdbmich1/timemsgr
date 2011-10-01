class EventType < ActiveRecord::Base
  default_scope :order => 'sortkey ASC'
    
  def self.get_tsd_event_types
    find_by_sql(["SELECT event_type FROM `kitstsddb`.event_type "])
  end
    
end
