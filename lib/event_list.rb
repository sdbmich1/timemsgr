module EventList
  def self.pgType pname
    pname ? @pgType = pname : @pgType   
  end 
  
  def self.getPgType type, pname
    pgType(pname) ? pgType(pname) == type ? true : false : true
  end
  
  def self.load_events user, pg, pname
    @events = PrivateEvent.current_events(user.ssid).paginate(:page=>pg, :per_page => 15) if getPgType('upcoming_page', pname)
    @past_events = PrivateEvent.past_events(user.ssid).paginate(:page=>pg, :per_page => 15) if getPgType('past_page', pname)    
  end
end