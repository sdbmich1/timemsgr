require 'ics'
require 'open-uri'
class ImportICSFeed
  include Schedule
    
  # read given file with list of ics filenames 
  def read_feeds(fname)
    File.foreach(fname) {|line| process_feed(line.split(',')[0], line.split(',')[1], line.split(',')[2])}
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
               
      new_event = CalendarEvent.find_or_initialize_by_pageextsourceID(uid, :event_type => 'ce', :event_title => etype + ': ' + cal.summary, 
        :cbody => cal.description, :contentsourceID => cid, :localGMToffset => offset, :endGMToffset => offset, :subscriptionsourceID => cid) 
      new_event.eventstartdate = new_event.eventstarttime = cal.dtstart.to_datetime
      new_event.eventenddate = new_event.eventendtime = cal.dtend.to_datetime  
       
      new_event.postdate = cal.created.to_datetime rescue nil
      new_event.contentsourceURL = cal.url rescue nil
      loc = cal.location rescue nil
      
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
