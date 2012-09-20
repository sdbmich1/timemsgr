require 'ics'
require 'open-uri'
class ImportICSFeed
  include Schedule
    
  # read given file with list of ics filenames 
  def read_feeds(fname)
    File.foreach(fname) {|line| process_feed(line.split(',')[0], line.split(',')[1], line.split(',')[2], line.split(',')[3])}
  end  
    
  # open and read ics file
  def process_feed(fname, channel, offset, etype)
    p "Channel: #{channel} | URL: #{fname}"
    schedule = ICS::Event.file(open(fname)) rescue nil
    schedule.map {|cal| process_event(cal, channel, offset, etype) } if schedule
  end
  
  # process each calendar event
  def process_event(cal, channel, offset, etype)    
    cid = LocalChannel.get_channel_by_name(channel).flatten 1    # get correct channels for events
    cid.map {|ch| add_event(cal, ch.channelID, offset, etype)} # add event to system
  end
  
  # add to system
  def add_event(cal, cid, offset, etype)    
    if cal.dtstart.to_date >= Date.today
      start_offset, end_offset = cal.dtstart.to_time.getlocal.utc_offset/3600, cal.dtend.to_time.getlocal.utc_offset/3600  
      uid = cal.uid =~ /[\)]/i ? cal.uid.split(')')[1] : cal.uid
      ename = etype + ': ' + cal.summary
               
      new_event = CalendarEvent.find_or_initialize_by_event_title_and_subscriptionsourceID(ename, cid) 
      new_event.event_type, new_event.event_title, new_event.cbody = 'ce', ename, cal.description  
      new_event.contentsourceID = new_event.subscriptionsourceID = cid
      new_event.localGMToffset = new_event.endGMToffset = offset
      new_event.eventstartdate = new_event.eventstarttime = cal.dtstart.to_time.advance(:hours => start_offset)
      new_event.eventenddate = new_event.eventendtime = cal.dtend.to_time.advance(:hours => end_offset)  
       
      new_event.postdate = cal.created.to_time rescue nil
      new_event.contentsourceURL = cal.url rescue nil
      loc = cal.location rescue nil

      #p "Event: #{new_event.event_title} | Descr: #{new_event.cbody}"
      
      # check if location exists          
      if loc
        new_event.location = loc 
        addr = Schedule.get_offset loc
        new_event.mapcity, new_event.mapstate, new_event.mapzip, new_event.mapcountry = addr[:city], addr[:state], addr[:zip], addr[:country] if addr
      end
      new_event.save(:validate=>false)
    end
  end    
end
