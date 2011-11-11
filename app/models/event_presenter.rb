class EventPresenter < KitsTsdModel

  belongs_to :event
  belongs_to :presenter
  belongs_to :private_event, :primary_key => :event_id
  
  validates :event_id, :presence => true
  validates :presenter_id, :presence => true, :uniqueness => { :scope => :event_id } 
end
