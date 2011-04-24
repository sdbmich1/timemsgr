class EventPageSection < ActiveRecord::Base
 # has_many :events, :class_name => "event", :foreign_key => "event_type"
  
  scope :active, 
            :joins => "LEFT JOIN `events` ON events.event_type = event_page_sections.event_type"

  default_scope :order => 'event_page_sections.rank ASC'
        
end
