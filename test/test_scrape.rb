require "open-uri"
require "nokogiri"
require 'rss/2.0'
require 'json'
require 'geokit'
#require 'feedzirra'
require 'mechanize'
require 'cgi'

def load_url(url)  
  doc = Nokogiri::HTML(open(url))
end

def get_art_events
  # use to scrape events from SF Chronicle DateBook section 1
  tags = ".title_content , :nth-child(5) div, :nth-child(7) div, #searchresults :nth-child(2) .search_result_content div, :nth-child(9) div, :nth-child(8) div, .serp_click_6, .serp_click_3, .serp_click_1, .serp_click_2"
  #url = 'http://events.sfgate.com/search?cat=1&city=San+Francisco&new=n&srad=85&st=event&swhat=&swhen=&swhere=&srss=50'
  url = 'http://events.sfgate.com/search?cat=1&city=San+Francisco&new=n&srad=85&srss=50&ssi=0&st=event&swhat=&swhen=&swhere=&sort=1'

  doc = load_url(url)  
  
  doc.css(tags).each do |item|
  #  result = item.css(".search_result_content div").count
    puts item.text
  end  
end

def rss_feed(feed_url)
  url = 'http://events.sfgate.com/search?cat=1&city=San+Francisco&new=n&rss=1&sort=1&srad=85&srss=50&st=event&svt=text&swhat=&swhen=&swhere='
  output = ""
  open(feed_url) do |http|
    response = http.read
    result = RSS::Parser.parse(response, false)
    output += "Feed Title: #{result.channel.title}<br />" 
    result.items.each_with_index do |item, i|
      output += "#{i+1}. #{item.title}<br />" if i > 10  
    end  
  end
  puts output
end

def feed_entries(cid, ssid)
#  feed_url = 'http://events.sfgate.com/search?cat=1&city=San+Francisco&new=n&rss=1&sort=1&srad=85&srss=50&st=event&svt=text&swhat=&swhen=&swhere='
  feed = Feedzirra::Feed.fetch_and_parse(feed_url) 
  add_entries(cid, ssid, feed.entries) 
end

def feed_update(cid, ssid, feed)
  feed = Feedzirra::Feed.update(feed)
  add_entries(cid, ssid, feed.new_entries) if feed.updated?
end

  # find day of the week for event to parse event text
  def parse_day(entry)
    Date::DAYNAMES.each do |wkdy|
      hdr = entry.title.split(", #{wkdy[0..2]}, ")
      if hdr.size == 1 
        next 
      else
        return hdr
      end
    end  
  end

  def add_entries(cid, ssid, feed_list)
    # process each feed item
    feed_list.each do |entry| 
    
      # get parse event text
      hdr = parse_day(entry)
      p hdr[0]
    
      # set event title
      etitle = hdr[0].split(' at ')[0]
    
      # set location
      loc = hdr[0].split(' at ')[1]
    
      # set dates
      sdt = DateTime.parse(hdr[1])
      edt = sdt.advance(:hours => 1)
    
      #    unless CalendarEvent.contentsourceURL == entry.id
      CalendarEvent.find_or_create_by_contentsourceURL(entry.id, :event_type => 'ce', :event_name => etitle, :location => loc,
        :eventstartdate => sdt, :eventenddate => edt, :eventstarttime => sdt, :eventendtime => edt,
        :contentsourceURL => entry.url, :cbody => entry.summary + ' ' + entry.url, :postdate => entry.published,
        :CreateDateTime => entry.published, :contentsourceID => cid, :subscriptionsourceID => ssid)
#    end
    end 
  end 
  
  def select_college_channel(title, school, descr)
    channel = []
    [['Opera|Choir|Theater|Symphony|Dance|Ballet|Concerto|Theatre', 'Performing Arts'],  
     ['Speaker|Lecture|Discussion|Talk|Author|Panel', 'Speaker'],
     ['Sculpture|Crafts|Art|Painting|Exhibit|Gallery', 'Art Activities'],  
     ['Screening|Film|Movie|Cinema', 'Film'], 
     ['Concert|Drama|Comedy','Lively']].each do |str|
       if !(title.downcase =~ /^.*\b(#{str[0].downcase})\b.*$/i).nil? || !(descr.downcase =~ /^.*\b(#{str[0].downcase})\b.*$/i).nil?
         channel << get_college_channel([school, str[1]].join('%')) 
       end      
     end
    channel << get_college_channel([school, "Consolidated"].join('%'))   
  end
  
  def get_channel(str, cnty, locale)
    LocalChannel.get_channel(str, cnty, locale)
  end
  
  def get_college_channel(school)
    LocalChannel.get_channel_by_name school
  end
   
  def chk_geocode(lat, long)
    url = ['http://maps.googleapis.com/maps/api/geocode/json?latlng=', [lat, long].join(','),'&sensor=false'].join('')
    str = JSON.parse(open(url).read)
    get_county str["results"][0]["address_components"] 
  end
  
  def get_county(item)
    result = item.detect { |addr| !(addr["types"][0] =~ /level_2/i).nil? }
    result["long_name"] if result
  end
  
  def read_feeds(fname, locale, offset)
    File.foreach(fname) {|line| xml_feed_entries(line, locale, offset)}
  end
 
  def xml_feed_entries(feed_url, locale, offset)
#    feed_url = 'http://events.sfgate.com/search?cat=1&city=San+Francisco&new=n&rss=1&sort=1&srad=85&srss=100&st=event&svt=text&swhat=&swhen=&swhere='
#    'http://events.sfgate.com/search?cat=3&city=San+Francisco&new=n&rss=1&sort=1&srad=85&srss=100&st=event&svt=text&swhat=&swhen=&swhere='    
#    doc.xpath("//title").map {|node| node.children.text }
    p "Feed #{feed_url}"
    doc = Nokogiri::XML(open(feed_url))
    doc.xpath("//item").count.times do |n|
      
      # process dates
      sdt = DateTime.parse(doc.xpath("//item//xCal:dtstart")[n].text)
      edt = doc.xpath("//item//xCal:dtend")[n].text
      edt.blank? ? enddt = sdt.advance(:hours => 2) : enddt = DateTime.parse(edt)
      
      # get event title and url
      etitle = doc.xpath("//item//title")[n].text.split(' at ')[0].split('Event: ')[1]
      url = doc.xpath("//item//link")[n].text 
      sid = doc.xpath("//item//id")[n].text      
      p "Item #{n}: #{etitle.html_safe}"

      # get county based on coordinates
      lat = doc.xpath("//item//geo:lat")[n].text
      lng = doc.xpath("//item//geo:long")[n].text
      
#      p "Long #{lng}: Lat #{lat}"
      county = chk_geocode(lat, lng)
            
      # find correct channel and location
      cid = LocalChannel.select_channel(etitle, county, locale).flatten 1
      cid.map {|channel| p "Channel: #{channel.channelID}" }

      # add event to calendar
#      cid.map {|channel| add_event(doc, n, sid, etitle[0..199], sdt, enddt, channel[0].channelID, url, offset)}
 
 #     p "County: #{county} " if county
 #     p "Channel: #{cid[0].channelID}"
    end     
  end
  
  def xml_sfstate_feed(feed_url, school, offset)
    agent = Mechanize.new
    agent.get(feed_url)
    
    # parse the appropriate links
    pages = agent.page.links.select { |l| !(l.href =~ /p_id/i).nil? }
    pages.each do |pg|
      
       # open target page
      target_page = pg.click
           
      # parse event id
      str = CGI.parse(pg.href)
      event_id = str["webcalendar.detail?p_id"][0]
      
      etitle = target_page.search('.summary').text
      sdt = target_page.search('.dtstart').text.split(': ')[1] rescue nil
      stm = target_page.search('.dtstart').text.split(': ')[2].split("\n")[0] rescue nil
      edt = target_page.search('.dtend').text rescue nil
      url = target_page.search('.url').text
      
      # set event times
      start_time = sdt && stm ? (sdt + stm).to_datetime : sdt.to_datetime 
      etime = (sdt + edt).to_datetime if sdt && edt 
      
#      p "Event : #{etitle} | #{sdt} | #{start_time} | #{etime}"
      
      # get event details
      loc = target_page.search('.location').text.split(': ')[1] 
      host = target_page.search('.organiser').text.split(': ')[1].strip
      contact = target_page.search('.contact').text.split(': ')[1].strip
      email = target_page.search('.email').text.split(': ')[1].strip
      phone = target_page.search('.phone').text.split(': ')[1].strip
      details = target_page.search('.description').text
      
      # find correct channel and location
      cid = LocalChannel.select_college_channel(etitle, school, details).flatten 1
      cid.map {|channel| p "Channel: #{channel.channelID}" }

      # add event to calendar
#      cid.map {|channel| add_college_event(url, etitle[0..199], details, Date.today, start_time, start_time, etime, channel.channelID, offset, loc, event_id, etime)}      
    end
    
  end
  
  
  def xml_stanford_feed(feed_url, school, offset)
    doc = Nokogiri::XML(open(feed_url))
    doc.xpath("//item").count.times do |n|
      
      # get event title and url
      etitle = doc.xpath("//item//title")[n].text
      url = doc.xpath("//item//link")[n].text
      
      # get and parse description
      descr = doc.xpath("//item//description")[n].text
      result = descr.split('<br/>')[0].split(' through ')
      
      # get start and end dates
      result[1] ? (edt, sdt = result[1].split('.')[0], result[0].split('from ')[1]) : (edt = sdt = result[0].split('Date: ')[1].split('.')[0]) 
       
      # get start time
      result[1] ? (stime = result[1].split('.')[1].split('.')[0]) : (stime = result[0].split('Date: ')[1].split('.')[1])
      start_time = stime.strip unless (stime =~ /AM/i).nil? && (stime =~ /PM/i).nil?
      
      p "Item: #{n} | Title: #{etitle}" 
      p "Start: #{sdt} | End: #{edt} "
      p "Start Time: #{start_time}" if start_time
      
      # get guid 
      gstr = doc.xpath("//item//guid")[n].text.split('/')
      guid = gstr[gstr.size-1]
      p "ID: #{guid}"
      
      # get location
      loc = descr.split('<br/>')[1].split('Location: ')[1]
      p "Loc: #{loc}"

      # get details
      details = descr.split('<br/>')[3].split("\n\n")[1]
      
      #get publication date
      pubdt = DateTime.parse(doc.xpath("//item//pubDate")[n].text)
                
      # find correct channel and location
      cid = select_college_channel(etitle, school, details)
      cid.map {|channel| p "Channel: #{channel[0].channelID}" }

      # add event to calendar
#      cid.map {|channel| add_college_event(url, etitle[0..199], details, pubdt, sdt, start_time, edt, channel[0].channelID, offset, loc, guid)}
    end   
  end
  
  include ResetDate
  def process_stanford_scrape(feed_url, school, sport, offset)
    prev_dt = ""
    doc = Nokogiri::XML(open(feed_url))
    cnt = doc.css(".row-text").count / 4
    cnt.times do |n|
      doc.css(".row-text")[n*4].text.blank? ? dt = prev_dt : dt = doc.css(".row-text")[n*4].text
      (dt =~ /.,/i).nil? ? (sdt = edt = parse_date(dt)) : (sdt = edt = get_date(dt)) unless dt.blank?
      
      etitle = doc.css(".row-text")[n*4+1].text.split("\n")[0]
      !(etitle =~ /^.*\b(at|vs)\b.*$/i).nil? ? etitle = [school, etitle].join(' ') : etitle
      
      loc = doc.css(".row-text")[n*4+2].text
      st = doc.css(".row-text")[n*4+3].text
      stime = Time.parse(doc.css(".row-text")[n*4].text + st) if (st =~ /TBA|All|W|L/i).nil? && sdt >= Date.today
      p "Item: #{n} | Title: #{etitle}" 
      p "Start: #{sdt} | End: #{edt} "
      p "Loc: #{loc}"      
      p "Start Time: #{stime}" if (st =~ /TBA|All|W|L/i).nil? && sdt >= Date.today
      
      # find correct channel and location
      cid = get_college_channel([school, sport].join(' '))
      cid.map {|channel| p "Channel: #{channel.channelID}" }
      
      # set prev date if case of double headers
      prev_dt = dt
    end    
  end
  
  def parse_pga_events(feed_url, sport, oset, x)
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
       # cid.map {|channel| add_pga_event(event[:url], event[:name], details, Date.today, sdt, edt, channel.channelID, offset || 0, loc)}

        p "Event #{n}: #{event[:name]} | Start Date: #{sdt} | End Date: #{edt} | Loc: #{loc} | City: #{city} | State: #{mstate}"
        p "PGA Tour Event. For more info visit #{event[:url]} "
        p details if details
      end
    end     
  end
  
  def process_lpga_events(feed_url, sport)
    doc = Nokogiri::HTML(open(feed_url)) 
    cnt = doc.css('.scheduleDate').count  
    
    cnt.times do |n|
      dt = doc.css('.scheduleDate')[n].text.compact.split(" - ")
      edt = Date.parse(dt[1]) rescue nil
      sdt = Date.parse(dt[0].split('2012 ')[1]) rescue nil
      
      loc = doc.css('.scheduleTournament')[n].text.split("\r\n")[6].compact.strip
      event = doc.css('.scheduleTournament')[n].text.split("\r\n")[3].compact.strip
      plyr = doc.css('.schedulePlayerThumb')[n].text.compact.strip
      purse = doc.css('.schedulePurse')[n].text.compact.strip
      
      # select channel
      cid = get_college_channel(sport)
      cid.map {|channel| p "Channel: #{channel.channelID}" }
        
      # get offset
      addr = get_offset loc unless loc.blank? 
      
      p "Event #{n}: #{event} | Start Date: #{sdt} | End Date: #{edt} "
      p "Loc: #{loc} | City: #{addr[:city]} | State: #{addr[:state]}" if addr
      details = 'Defending Champion: ' + plyr + "\n" + 'Purse: ' + purse unless plyr.blank?
      p details if details
       
    end
  end
  
  # returns time offset for a given location
  def get_offset(loc) 
    addr = {}  
    res = Geokit::Geocoders::GoogleGeocoder.geocode(loc)
    url = ['http://www.earthtools.org/timezone', res.lat, res.lng].join("/") if res.success    
    doc = Nokogiri::XML(open(url)) if url
    offset = doc.xpath("//offset").text.to_i if doc
    addr = {:city=>res.city, :state=>res.state, :offset=>offset||0, :zip=>res.zip, :country=>res.country} if res.success
  end
  
  def set_end_date(sdate, edate, edt)
    (edate - sdate).days > 4.days || edate < sdate ? Date.parse([sdate.year, sdate.month, edt].join('-')) : edate
  end
   
  def get_date(dt)
     Date.parse(dt).strftime('%A')[0..2] == dt[0..2] ? Date.parse(dt) : Date.parse(dt) - 1.year
  end

  def add_college_event(*args)
    CalendarEvent.find_or_create_by_contentsourceURL(args[0][0..254], 
        :event_type => 'ce', :event_title => args[1], :cbody => args[2], :postdate => args[3],
        :eventstartdate => args[4], :eventstarttime => args[5], :eventenddate => args[6], 
        :contentsourceURL => args[0][0..254], :location => args[9][0..254],
        :contentsourceID => args[7], :localGMToffset => args[8], :endGMToffset => args[8],
        :subscriptionsourceID => args[7], :pageextsourceID => args[10])
  end
  
  def add_pga_event(*args)
    CalendarEvent.find_or_create_by_contentsourceURL(args[0][0..254], 
        :event_type => 'ce', :event_title => args[1], :cbody => args[2], :postdate => args[3],
        :eventstartdate => args[4], :eventenddate => args[5], 
        :contentsourceURL => args[0][0..254], :location => args[8][0..254],
        :contentsourceID => args[6], :localGMToffset => args[7], :endGMToffset => args[7],
        :subscriptionsourceID => args[6])
  end
  
  def add_event(doc, n, *args)
    CalendarEvent.find_or_create_by_pageextsourceID(args[0], 
        :event_type => 'ce', :event_title => args[1],
        :cbody => doc.xpath("//item//description")[n].text + ' ' + doc.xpath("//item//phone")[n].text,
        :postdate => DateTime.parse(doc.xpath("//item//pubDate")[n].text),
        :eventstartdate => args[2], :eventstarttime => args[2], :eventenddate => args[3], :eventendtime => args[3],
        :contentsourceURL => args[5][0..254],   
        :location => doc.xpath("//item//xCal:location")[n].text,
        :mapplacename => doc.xpath("//item//xCal:adr//xCal:x-calconnect-venue-name")[n].text[0..59],
        :mapstreet => doc.xpath("//item//xCal:adr//xCal:x-calconnect-street")[n].text,
        :mapcity => doc.xpath("//item//xCal:adr//xCal:x-calconnect-city")[n].text,
        :mapstate => doc.xpath("//item//xCal:adr//xCal:x-calconnect-region")[n].text,
        :mapzip => doc.xpath("//item//xCal:adr//xCal:x-calconnect-postalcode")[n].text,
        :mapcountry => doc.xpath("//item//xCal:adr//xCal:x-calconnect-country")[n].text,
        :pageextsourceID => doc.xpath("//item//id")[n].text,
        :contentsourceID => args[4], :localGMToffset => args[6], :endGMToffset => args[6],
        :subscriptionsourceID => args[4])
  end
  