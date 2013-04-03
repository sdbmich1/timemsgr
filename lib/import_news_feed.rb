require "open-uri"
require "nokogiri"
require 'json'
class ImportNewsFeed  
  include Schedule
  
  # add event to system
  def add_event(doc, n, *args)
#    p 'Add event ' + args[1][0..199]
    new_event = CalendarEvent.find_or_initialize_by_pageextsourceID(:pageextsourceID => doc.xpath("//item//id")[n].text, 
        :event_type => 'ce', :event_title => args[1][0..199],
        :cbody => doc.xpath("//item//description")[n].text, 
        :postdate => DateTime.parse(doc.xpath("//item//pubDate")[n].text),
        :eventstartdate => args[2], :eventstarttime => args[2], :eventenddate => args[3], :eventendtime => args[3],
        :contentsourceURL => args[5][0..99],   
        :location => doc.xpath("//item//xCal:location")[n].text,
        :mapplacename => doc.xpath("//item//xCal:adr//xCal:x-calconnect-venue-name")[n].text[0..59],
        :mapstreet => doc.xpath("//item//xCal:adr//xCal:x-calconnect-street")[n].text[0..39],
        :mapcity => doc.xpath("//item//xCal:adr//xCal:x-calconnect-city")[n].text[0..39],
        :mapstate => doc.xpath("//item//xCal:adr//xCal:x-calconnect-region")[n].text[0..24],
        :mapzip => doc.xpath("//item//xCal:adr//xCal:x-calconnect-postalcode")[n].text[0..9],
        :mapcountry => doc.xpath("//item//xCal:adr//xCal:x-calconnect-country")[n].text[0..39],
        :contactphone => doc.xpath("//item//phone")[n].text[0..14],
        :contentsourceID => args[4], :localGMToffset => args[6], :endGMToffset => args[6],
        :subscriptionsourceID => args[4]) 
    new_event.longitude, new_event.latitude = doc.xpath("//item//geo:long")[n].text.to_f, doc.xpath("//item//geo:lat")[n].text.to_f     
    new_event.imagelink = doc.xpath("//item//images//url")[n].text rescue nil
    new_event.save(:validate=>false)
  end  
  
  # parse xml feeds from given url
  def xml_feed_entries(feed_url, locale, offset)
    p "Feed #{feed_url}"
    doc = Nokogiri::XML(open(feed_url))
    doc.xpath("//item").count.times do |n|
      
      # process dates
      sdt = DateTime.parse(doc.xpath("//item//xCal:dtstart")[n].text) rescue nil
      edt = doc.xpath("//item//xCal:dtend")[n].text
      edt.blank? ? enddt = sdt.advance(:hours => 2) : enddt = DateTime.parse(edt)
      
      # get event title and url
      etitle = doc.xpath("//item//title")[n].text.split(' at ')[0]
      url = doc.xpath("//item//link")[n].text 
      sid = doc.xpath("//item//id")[n].text      

      # get county based on coordinates
      lat = doc.xpath("//item//geo:lat")[n].text
      lng = doc.xpath("//item//geo:long")[n].text
      county = Schedule.chk_geocode(lat, lng) rescue nil
        
      # add only current events      
      if sdt >= Date.today
        
        # find correct channel and location
        cid = LocalChannel.select_channel(etitle, county, locale).flatten 1
#      cid.map {|channel| p "Channel: #{channel.channelID}" }

        # add event to calendar
        cid.map {|channel| add_event(doc, n, sid, etitle[0..199], sdt, enddt, channel.channelID, url, offset)} if cid
#        add_event(doc, n, sid, etitle[0..199], sdt, enddt, cid[0].channelID, url, offset) if cid
      end
    end     
  end
  
  # read given file with list of url feeds for a certain city
  def read_feeds(fname, locale, offset)
    File.foreach(fname) {|line| xml_feed_entries(line, locale, offset)}
  end
  
end