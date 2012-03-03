require "open-uri"
require "nokogiri"
require 'json'
class ImportNewsFeed
  
  # get channel to map event content
  def get_channel(str, cnty, locale)
    LocalChannel.get_channel(str, cnty, locale)
  end
   
  # use to determine county & city of event based on google api 
  def chk_geocode(lat, long)
    url = ['http://maps.googleapis.com/maps/api/geocode/json?latlng=', [lat, long].join(','),'&sensor=false'].join('')
    str = JSON.parse(open(url).read)
    get_county str["results"][0]["address_components"] 
  end
  
  # grabs county name from json hash returned from google api
  def get_county(item)
    result = item.detect { |addr| !(addr["types"][0] =~ /level_2/i).nil? }
    result["long_name"] if result
  end
  
  # use regex to match key words in title to find right channels
  def select_channel(title, cnty, loc)
    channel = []
    [['Sculpture|Art|Painting|Exhibit|Gallery|Artist|Artwork|Museum|Curated|Arts|Crafts', 'Galleries'], 
     ['Preschool|Teen|Children|Kids|Kindergarten|Elementary', 'Youth'], ['Elementary','Elementary'],
     ['Dance|Concert|Band|Performance|Music|Ball|Jazz|Salsa|DJ|Ballroom|CD|Blues|Reggae|Rehearsal|Rock|Pop|Noise|Country Music|Quartet|Trio|Quintet', 'Music Scene'],  
     ['Parade', 'Parade'], ['Comedy|Funny|Comedian|Improv|Laugh', 'Comedy'],
     ['Culinary|Food|Wine|Cooking|Taste|Brunch|Dinner|Chocolate|Chef|Kitchen|Farmers|Barbeque|Tasting|Lunch|Dining|Coffee|Dine|Potluck|Winery|Feed|Feast|Beer', 'Food'],  
     ['Jazz', 'Jazz'], ['Blues', 'Blues'], ['Bluegrass|Country Music|Country', 'Country Music'], ['Private School|High School', 'High School'], 
     ['Fiesta|Festival|Fair|Show|Celebration|Fireworks|Exhibition|Flea|Fest', 'Festival'],
     ['Volunteer|Charity|Fundraiser|Gala|Benefit|Luncheon|Fundraising', 'Charity'], 
     ['Speaker|Lecture|Discussion|Talk|Author|Panel|Book|Reading|Literature|Stories', 'Speaker'],
     ['Screening|Film|Movie|Cinema|3D', 'Film'], ['Science|History','Science'],
     ['Church|Religion|Baptist|Islam|Catholic|Christ|Episcopal|Evangelical|Buddist|Hindu|Mormon|Christian|Methodist', 'Church'],
     ['R&B|Hip-Hop|Soul','Hip-Hop'], ['Rock|Pop', 'Rock'], ['Medical|Health|Medicine','Health'],
     ['Book|Reading|Literature|Stories|Author', 'Book'],['Senior', 'Senior'],
     ['Orchestra|Piano|Violin|Cello|Musical|Recital|Cello|Symphony|Concerto', 'Classical'],
     ['Sale|Offer','Promotions'],     
     ['Opera|Choir|Theater|Symphony|Ballet|Concerto|Theatre|Play|Choregraphy|Dance|Orchestra|Piano|Violin|Cello|Musical|Recital', 'Performing Arts'],
     ['Zoo|Animals|Aquarium', 'Zoo'], ['Park', 'Parks'], 
     ['Meeting|Conference', 'Meeting']].each do |str|
      if !(title.downcase =~ /^.*\b(#{str[0].downcase})\b.*$/i).nil? 
        channel << get_channel(str[1],cnty, loc) 
      end
    end 
    channel << get_channel('Consolidated: All', cnty, loc) unless channel   
  end
 
  # add event to system
  def add_event(doc, n, *args)
    CalendarEvent.first_or_create_by_pageextsourceID(args[0], 
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
  
  # parse xml feeds from given url
  def xml_feed_entries(feed_url, locale, offset)
    doc = Nokogiri::XML(open(feed_url))
    doc.xpath("//item").each do |n|
      
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
      cid.map {|channel| add_event(doc, n, sid, etitle[0..199], sdt, enddt, channel.channelID, url, offset)}
    end     
  end
  
  # read given file with list of url feeds for a certain city
  def read_feeds(fname, locale, offset)
    File.foreach(fname) {|line| xml_feed_entries(line, locale, offset)}
  end
  
end