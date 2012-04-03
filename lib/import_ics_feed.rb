require 'ics'
require 'open-uri'
class ImportICSFeed
  include Schedule
    
  # read given file with list of ics filenames 
  def read_feeds(fname)
    File.foreach(fname) {|line| process_feed(line.split(',')[0], line.split(',')[1], line.split(',')[2])}
  end  
    
  # open and read ics file
  def process_feed(fname, channel, offset)
    schedule = ICS::Event.file(open(fname)) 
    schedule.map {|cal| process_event(cal, channel, offset) }
  end
  
  # process each calendar event
  def process_event(cal, channel, offset)    
    cid = LocalChannel.get_channel_by_name channel    # get correct channels for events
    cid.map {|ch| add_event(cal, ch.channelID, offset)} #add event to system
  end
  
  # add to system
  def add_event(cal, cid, offset)
    addr = Schedule.get_offset cal.location
    CalendarEvent.find_or_create_by_pageextsourceID(cal.uid, :event_type => 'ce', :event_title => cal.summary, 
        :cbody => cal.description, :postdate => cal.created.to_datetime,
        :eventstartdate => cal.dtstart.to_datetime, :eventstarttime => cal.dtstart.to_datetime, 
        :eventenddate => cal.dtend.to_datetime, :eventendtime => cal.dtend.to_datetime, 
        :contentsourceURL => cal.url, :location => cal.location,
        :mapcity => addr[:city], :mapstate => addr[:state], :mapzip => addr[:zip], :mapcountry => addr[:country],
        :contentsourceID => cid, :localGMToffset => addr[:offset], :endGMToffset => addrr[:offset],
        :subscriptionsourceID => cid, :pageextsourceID => cal.uid) if cal.dtstart.to_datetime > Time.now
  end    
end
