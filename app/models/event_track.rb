class EventTrack < KitsTsdModel
  belongs_to :event
             
  validates :name, :presence => true, :unless => 'description.nil?'

  def self.get_track(eid)
    where(:event_id => eid).order(:name)
  end
end
