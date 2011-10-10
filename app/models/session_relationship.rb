class SessionRelationship < KitsTsdModel
  belongs_to :event
  belongs_to :session, :class_name => "Event"
  
  validates :event_id, :presence => true
  validates :session_id, :presence => true, :uniqueness => { :scope => :event_id }  
end
