class EventPresenter < KitsTsdModel

  belongs_to :event
  belongs_to :presenter
  
  validates :event_id, :presence => true
  validates :presenter_id, :presence => true, :uniqueness => { :scope => :event_id } 
end
