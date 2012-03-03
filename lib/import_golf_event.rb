require "open-uri"
require "nokogiri"
require 'json'
require 'geokit'
class ImportGolfEvent
  def parse_golf_events(feed_url, sport, oset, x)
    events = []
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
        cid = get_college_channel(sport)
        cid.map {|channel| p "Channel: #{channel.channelID}" }
        
        # get offset
        offset = get_offset [city, mstate].join(', ') unless city.blank? 
        
        # add event to calendar
        cid.map {|channel| add_golf_event(event[:url], event[:name], details, Date.today, sdt, edt, channel.channelID, offset || 0, loc)}
      end
    end     
  end
  
  # returns time offset for a given location
  def get_offset(loc)   
    res = Geokit::Geocoders::GoogleGeocoder.geocode(loc)
    url = ['http://www.earthtools.org/timezone', res.lat, res.lng].join("/") if res    
    doc = Nokogiri::XML(open(url)) if url
    doc.xpath("//offset").text.to_i if doc
  end
  
  def set_end_date(sdate, edate, edt)
    (edate - sdate).days > 4.days || edate < sdate ? Date.parse([sdate.year, sdate.month, edt].join('-')) : edate
  end  
  
  def add_golf_event(*args)
    CalendarEvent.find_or_create_by_contentsourceURL(args[0][0..254], 
        :event_type => 'ce', :event_title => args[1], :cbody => args[2], :postdate => args[3],
        :eventstartdate => args[4], :eventenddate => args[5], 
        :contentsourceURL => args[0][0..254], :location => args[8][0..254],
        :contentsourceID => args[6], :localGMToffset => args[7], :endGMToffset => args[7],
        :subscriptionsourceID => args[6])
  end  
end