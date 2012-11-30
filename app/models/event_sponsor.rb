class EventSponsor < KitsTsdModel

  belongs_to :event #, :foreign_key=>:eventid
  belongs_to :sponsor
#  belongs_to :private_event, :primary_key => :event_id
  
  validates :event_id, :presence => true
  validates :sponsor_id, :presence => true, :uniqueness => { :scope => :event_id } 
end
