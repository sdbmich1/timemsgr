require "open-uri"
require "nokogiri"
require 'rss/2.0'
require 'json'
#require 'feedzirra'

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

def rss_feed
  url = 'http://events.sfgate.com/search?cat=1&city=San+Francisco&new=n&rss=1&sort=1&srad=85&srss=50&st=event&svt=text&swhat=&swhen=&swhere='
  output = ""
  open(url) do |http|
    response = http.read
    result = RSS::Parser.parse(response, false)
    output += "Feed Title: #{result.channel.title}<br />" 
    result.items.each_with_index do |item, i|
      output += "#{i+1}. #{item.title}<br />" if i &lt; 10  
    end  
  end
  puts output
end

def feed_entries(cid, ssid)
  feed_url = 'http://events.sfgate.com/search?cat=1&city=San+Francisco&new=n&rss=1&sort=1&srad=85&srss=50&st=event&svt=text&swhat=&swhen=&swhere='
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
  
  def select_channel(title, cnty, loc)
    [['Gallery', 'Galleries'], ['Museum', 'Museum'], ['Aquarium', 'Aquarium'], ['Festival', 'Festival'], ['Exhibit', 'Exhibit'],
     ['Preschool', 'Youth'], ['Teen', 'Youth'], ['Painting', 'Galleries'], ['Ballet', 'Performing Arts'], ['Dance', 'Performing Arts'], 
     ['Opera', 'Performing Arts'], ['Symphony', 'Performing Arts'], ['Crafts', 'Museum'],
     ['Choir', 'Performing Arts'], ['Theatre', 'Performing Arts'], ['Dance', 'Music Scene'], ['Comedy', 'Comedy'], 
     ['Parade', 'Parade'], ['Children', 'Youth'], ['Ball', 'Music Scene'], ['Fair', 'Fair'], ['Dance', 'Dance'],
     ['Culinary', 'Food'], ['Food', 'Food'], ['Jazz', 'Jazz'], ['Private School', 'High School'], ['Fiesta', 'Festival'],
     ['Wine', 'Food'], ['Chocolate', 'Food'], ['Volunteer', 'Charity'], ['Cooking', 'Food'], ['Dinner', 'Food'], 
     ['Taste', 'Food'], ['Brunch', 'Food'], ['Kitchen', 'Food'], ['Screening', 'Film'], ['Film','Film'],
     ['Zoo', 'Zoo'], ['Zoo', 'Parks'], ['Concert','Music Scene'], ['Concerto', 'Performing Arts'],
     ['Fundraiser','Charity'], ['Meeting', 'Meeting'], ['Chef', 'Food'], ['Lecture', 'Speaker']].each do |str|
      if !(title =~ /#{str[0]}/i).nil? 
        return get_channel(str[1],cnty, loc) 
      end
    end 
    return get_channel('Consolidated', cnty, loc)   
  end
  
  def select_college_channel(title, school)
    [['Painting', 'Art Activities'], ['Ballet', 'Performing Arts'], ['Dance', 'Performing Arts'], 
     ['Opera', 'Performing Arts'], ['Symphony', 'Performing Arts'], ['Crafts', 'Art Activities'],
     ['Choir', 'Performing Arts'], ['Theatre', 'Performing Arts'], ['Lecture', 'Speaker'],
     ['Talk', 'Speaker'], ['Sculpture', 'Art Activities'], ['Author', 'Speaker'], 
     ['Art', 'Art Activities'], ['Screening', 'Film'], ['Film','Film'], ['Concerto', 'Performing Arts'],
     ['Concert','Lively'],['Drama','Lively'],['Theater', 'Performing Arts']].each do |str|
       if !(title =~ /#{str[0]}/i).nil? 
         return get_college_channel([school, str[1]].join('%')) 
       end      
     end
    return get_college_channel([school, "Consolidated"].join('%'))   
  end
  
  def get_channel(str, cnty, locale)
    LocalChannel.get_channel(str, cnty, locale)
  end
  
  def get_college_channel(school)
    LocalChannel.get_college_channel school
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
#      p "Item #{n}: #{etitle.html_safe}"

      # get county based on coordinates
      lat = doc.xpath("//item//geo:lat")[n].text
      lng = doc.xpath("//item//geo:long")[n].text
      
#      p "Long #{lng}: Lat #{lat}"
      county = chk_geocode(lat, lng)
            
      # find correct channel and location
      cid = select_channel(etitle, county, locale)

      # add event to calendar
      cid.map {|channel| add_event(doc, n, sid, etitle[0..99], sdt, enddt, channel.channelID, url, offset)}
 
 #     p "County: #{county} " if county
 #     p "Channel: #{cid[0].channelID}"
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
      
      # get location
      loc = descr.split('<br/>')[1].split('Location: ')[1]
      p "Loc: #{loc}"
                
      # find correct channel and location
      cid = select_college_channel(etitle, school)
      p "Channel: #{cid[0].channelID}" if cid[0]

      # get details
      details = descr.split('<br/>')[3].split("\n\n")[1]
#      p details
      
      #get publication date
      pubdt = DateTime.parse(doc.xpath("//item//pubDate")[n].text)

      # add event to calendar
      cid.map {|channel| add_college_event(url, etitle[0..99], details, pubdt, sdt, start_time, edt, channel.channelID, offset, loc)}
    end   
  end

  def add_college_event(*args)
    CalendarEvent.find_or_create_by_contentsourceURL(args[0][0..254], 
        :event_type => 'ce', :event_name => args[1], :cbody => args[2], :postdate => args[3],
        :eventstartdate => args[4], :eventstarttime => args[5], :eventenddate => args[6], 
        :contentsourceURL => args[0][0..254], :location => args[9][0..254],
        :contentsourceID => args[7], :localGMToffset => args[8], :endGMToffset => args[8],
        :subscriptionsourceID => args[7])
  end
  
  def add_event(doc, n, *args)
    CalendarEvent.find_or_create_by_pageextsourceID(args[0], 
        :event_type => 'ce', :event_name => args[1],
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
  