module ImportEvent
  
  # import events from google calendar for user
  def self.gcal_import email, pwd, usr 
    gservice = GCal4Ruby::Service.new # initialize service
    res = gservice.authenticate(email, pwd) rescue nil
    if res
      @events = GCal4Ruby::Event.find(gservice, "") # grab events     
      add_import_events usr # add import events to db
    end
    res
  end
  
  def self.add_import_events usr
    @events.each do |e|
      if !e.title.blank? && e.start_time >= Time.now && (e.attendees[0][:name] =~ /Holidays/i).nil?    
        start_offset, end_offset = e.start_time.getlocal.utc_offset/3600, e.end_time.getlocal.utc_offset/3600           
        new_event = PrivateEvent.new(:event_name => e.title, :event_type => 'other', :cbody => e.content,                                      
                                     :bbody => e.content, :location => e.where)
        new_event.pageexttype, new_event.pageextsrc = 'Google','html'
        new_event.contentsourceID = new_event.subscriptionsourceID = usr.ssid
        new_event.localGMToffset = new_event.endGMToffset = usr.localGMToffset
        new_event.eventstartdate = new_event.eventstarttime = e.start_time.advance(:hours=>start_offset)
        new_event.eventenddate = new_event.eventendtime = e.end_time.advance(:hours=>end_offset)
        new_event.save
      end
    end
  end
end