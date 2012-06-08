require "open-uri"
require "nokogiri"
require 'json'
require 'geokit'
class ImportGolfEvent
  include Schedule
  
  def parse_golf_events(feed_url, sport, oset, x, tour)
    events, addr = [], {}
    doc = Nokogiri::HTML(open(feed_url)) 
    
    # set array of event names & links  
    doc.css('.tourSchArrowFront').map {|item| events << {:name =>item.text, :url => item.attributes["href"]}}     
    cnt = doc.css('td , td , td , .tourSchArrowFront').count
    
    # loop thru each row to parse schedule; 6 items per row
    oset.step(cnt, x) do |n|
      dstr = doc.css('td , td , td , .tourSchArrowFront')[n].content
      descr = doc.css('td , td , td , .tourSchArrowFront')[n+1].content
      
      # use name array to parse description for matching event name
      event = events.detect {|e| !(descr =~ /#{e[:name]}/i).nil? }  
            
      # parse start date
      dt = dstr.split("\n")[0].split(" - ")[0]
      (sdt = Date.parse(dt)) rescue nil # p 'Invalid Date'
           
      # parse end date     
      dt2 = dstr.split("\n")[0].split(" - ")[1]
      edt = set_end_date sdt, Date.parse(dt2), dt2 if sdt
      
      # get site location
      if event && sdt
        lstr = descr.split(event[:name])[1].split('Purse')[0].split(",\n")  # get location string
        loc, city, mstate = lstr[0].compact.strip, lstr[1].compact.strip, lstr[2].split("\n")[1].compact.strip # get location, city, state
        !(event[:url].to_s.split("/")[0] =~ /http/i).nil? ? event[:url] : event[:url] = ['http://www.pgatour.com', event[:url]].join('')  # set url  
        
        # event details
        str = doc.css('td , td , td , .tourSchArrowFront')[n+3].content.compact.split('$')
        details = 'Defending Champion: ' + str[0] + "\n" + 'Purse: $' + str[1].split(' ')[0] unless str[1].blank?

        # select channel
        cid = LocalChannel.get_channel_by_name(sport)
        
        # get offset
        addr = Schedule.get_offset [city, mstate].join(', ') unless city.blank? 
        
        # add event to calendar
        cid.map {|channel| add_golf_event(event[:url], [tour, event[:name]].join(' '), details, Date.today, sdt, edt, channel.channelID, loc, addr)} if addr
      end
    end     
  end
  
  def process_lpga_events(feed_url, sport, tour)
    addr = {}
    doc = Nokogiri::HTML(open(feed_url)) 
    cnt = doc.css('.scheduleDate').count  
    
    cnt.times do |n|
      # parse dates
      dt = doc.css('.scheduleDate')[n].text.compact.split(" - ")
      edt = Date.parse(dt[1]) rescue nil
      sdt = Date.parse(dt[0].split('2012 ')[1]) rescue nil
      
      loc = doc.css('.scheduleTournament')[n].text.split("\r\n")[6].compact.strip
      event = doc.css('.scheduleTournament')[n].text.split("\r\n")[3].compact.strip
      plyr, purse = doc.css('.schedulePlayerThumb')[n].text.compact.strip, doc.css('.schedulePurse')[n].text.compact.strip
      details = 'Defending Champion: ' + plyr + "\n" + 'Purse: ' + purse unless plyr.blank?
      
      # select channel
      cid = LocalChannel.get_channel_by_name(sport)
        
      # get offset
      addr = Schedule.get_offset loc unless loc.blank? 
      
      # add event to calendar
      cid.map {|channel| add_golf_event(feed_url, [tour, event].join(' '), details, Date.today, sdt, edt, channel.channelID, loc, addr)} if addr    
    end
  end
  
  def set_end_date(sdate, edate, edt)
    (edate - sdate).days > 4.days || edate < sdate ? Date.parse([sdate.year, sdate.month, edt].join('-')) : edate
  end 
    
  def add_golf_event(*args)
    event = CalendarEvent.find_or_initialize_by_event_title(args[1][0..199], 
        :event_type => 'ce', :event_title => args[1][0..199], :cbody => args[2], :postdate => args[3],
        :eventstartdate => args[4], :eventenddate => args[5], 
        :contentsourceURL => args[0][0..99], :location => args[7][0..254],
        :contentsourceID => args[6], :subscriptionsourceID => args[6])
        
    event.eventstarttime = (args[4].to_date.to_s + ' 7:00 AM').to_datetime
    event.eventendtime = (args[5].to_date.to_s + ' 6:00 PM').to_datetime
    event.localGMToffset = event.endGMToffset = args[8][:offset] if args[8]
    event.mapstate = args[8][:state][0..24] if args[8][:state]    
    event.mapcity, event.mapzip, event.mapcountry = args[8][:city], args[8][:zip], args[8][:country] if args[8] 
    event.save      
  end  
end