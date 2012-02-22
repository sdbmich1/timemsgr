require "open-uri"
require "nokogiri"
require 'json'
class ImportFeed
  
  def get_channel(str, cnty, locale)
    LocalChannel.get_channel(str, cnty, locale)
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
 
  def add_event(doc, n, *args)
    CalendarEvent.first_or_create_by_pageextsourceID(args[0], 
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
  
  def xml_feed_entries(feed_url, locale, offset)
    doc = Nokogiri::XML(open(feed_url))
    doc.xpath("//item").count.times do |n|
      
      # process dates
      sdt = DateTime.parse(doc.xpath("//item//xCal:dtstart")[n].text)
      edt = doc.xpath("//item//xCal:dtend")[n].text
      edt.blank? ? enddt = sdt.advance(:hours => 2) : enddt = DateTime.parse(edt)
      
      # get event title and url
      etitle = doc.xpath("//item//title")[n].text.split(' at ')[0]
      url = doc.xpath("//item//link")[n].text 
      sid = doc.xpath("//item//id")[n].text      

      # get county based on coordinates
      lat = doc.xpath("//item//geo:lat")[n].text
      lng = doc.xpath("//item//geo:long")[n].text
      county = chk_geocode(lat, lng)
            
      # find correct channel and location
      cid = select_channel(etitle, county, locale)

      # add event to calendar
      cid.map {|channel| add_event(doc, n, sid, etitle[0..99], sdt, enddt, channel.channelID, url, offset)}
    end     
  end
  
  def read_feeds(fname, locale, offset)
    File.foreach(fname) {|line| xml_feed_entries(line, locale, offset)}
  end
  
end