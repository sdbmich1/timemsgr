class EventSite < KitsTsdModel
  belongs_to :event
              
  validates :name, :presence => true, :unless => 'description.nil?'
end
