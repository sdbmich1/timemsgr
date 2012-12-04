class EventTrack < KitsTsdModel
  belongs_to :event
  COLORS = %W(blue green orange red yellow grey purple brown black)
             
  validates :name, :presence => true, :unless => 'description.nil?'

  def self.get_track(eid)
    where(:event_id => eid).order(:name)
  end
  
  def self.get_color eid, trk_name
    parent_event = SessionRelationship.find_by_session_id eid
    EventTrack.get_track(parent_event.event_id).each_with_index do |trk, i|       
      return COLORS[i] if trk.name == trk_name
    end
    return COLORS.last
  end
end
