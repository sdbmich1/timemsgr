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
      stime, etime = e.start_time.to_time, e.end_time.to_time rescue nil
      if !e.title.blank? && stime >= Time.now && (e.attendees[0][:name] =~ /Holidays/i).nil?    
        start_offset, end_offset = stime.getlocal.utc_offset/3600, etime.getlocal.utc_offset/3600           
        new_event = PrivateEvent.find_or_initialize_by_event_name_and_eventstartdate(e.title, stime)
        new_event.pageexttype, new_event.pageextsrc = 'Google','html'
        new_event.contentsourceID = new_event.subscriptionsourceID = usr.ssid
        new_event.cbody, new_event.event_type, new_event.location = e.content, 'other', e.where
        new_event.localGMToffset = new_event.endGMToffset = usr.localGMToffset
        new_event.eventstartdate = new_event.eventstarttime = stime.advance(:hours=>start_offset)
        new_event.eventenddate = new_event.eventendtime = etime.advance(:hours=>end_offset)
        new_event.save
      end
    end
  end
end