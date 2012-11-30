class EventExhibitor < KitsTsdModel

  belongs_to :event #, :foreign_key=>:eventid
  belongs_to :exhibitor
  
  validates :event_id, :presence => true
  validates :exhibitor_id, :presence => true, :uniqueness => { :scope => :event_id } 
end
