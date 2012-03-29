require "open-uri"
require "nokogiri"
require 'json'
include ResetDate
class ImportCollegeFeed
    
  # parse xml feeds from given url
  def read_stanford_feed(feed_url, school, offset)
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
      
      # get location
      loc = descr.split('<br/>')[1].split('Location: ')[1]

      # get details
      details = descr.split('<br/>')[3].split("\n\n")[1]
      
      #get publication date
      pubdt = DateTime.parse(doc.xpath("//item//pubDate")[n].text)
      
      # get guid 
      gstr = doc.xpath("//item//guid")[n].text.split('/')
      guid = gstr[gstr.size-1]
                
      # find correct channel and location
      cid = LocalChannel.select_college_channel(etitle, school, details)

      # add event to calendar
      cid.map {|channel| add_college_event(url[0..254], etitle, details, pubdt, sdt, start_time, edt, channel[0].channelID, offset, loc, guid)}
    end   
  end
  
  # read given file with list of url feeds
  def read_feeds(fname, school, offset)
    File.foreach(fname) do |line| 
      fname = "#{line.split(',')[0]}".chomp
      process_stanford_scrape(fname, school, "#{line.split(',')[1]}".chomp.strip, offset) unless fname.blank?
    end
  end  
  
  def process_stanford_scrape(feed_url, school, sport, offset)
    prev_dt = ""    
    doc = Nokogiri::XML(open(feed_url)) #open feed
    
    # set reader to process four items on each row
    cnt = doc.css(".row-text").count / 4
    cnt.times do |n|
      
      # get start date; set to prev start date if blank
      doc.css(".row-text")[n*4].text.blank? ? dt = prev_dt : dt = doc.css(".row-text")[n*4].text
      
      # parse date according to string
      (dt =~ /.,/i).nil? ? (sdt = edt = parse_date(dt)) : (sdt = edt = get_date(dt)) unless dt.blank?
      
      #set event title
      etitle = doc.css(".row-text")[n*4+1].text.split("\n")[0]
      !(etitle =~ /^.*\b(at|vs)\b.*$/i).nil? ? etitle = [school, etitle].join(' ') : etitle
      
      loc = doc.css(".row-text")[n*4+2].text
      st = doc.css(".row-text")[n*4+3].text
     
      # set start time
      stime = Time.parse(doc.css(".row-text")[n*4].text + st) if (st =~ /TBA|All|W|L/i).nil? && sdt >= Date.today
      
      # find correct channel and location
      cid = LocalChannel.get_channel_by_name([school, sport].join(' '))
     
      # add event to calendar
      cid.map {|channel| add_scraped_event(feed_url[0..254], etitle, sport, Date.today, sdt, stime, edt, channel.channelID, offset, loc)}      
      
      # set prev date if case of double headers
      prev_dt = dt
    end    
  end
  
  # check day of week to ensure correct year for date
  def get_date(dt)
    Date.parse(dt).strftime('%A')[0..2] == dt[0..2] ? Date.parse(dt) : Date.parse(dt) - 1.year
  end

  # add to system
  def add_college_event(*args)
    CalendarEvent.find_or_create_by_pageextsourceID(args[10], 
        :event_type => 'ce', :event_title => args[1][0..199], :cbody => args[2], :postdate => args[3],
        :eventstartdate => args[4], :eventstarttime => args[5], :eventenddate => args[6], 
        :contentsourceURL => args[0], :location => args[9][0..254],
        :contentsourceID => args[7], :localGMToffset => args[8], :endGMToffset => args[8],
        :subscriptionsourceID => args[7], :pageextsourceID => args[10])
  end 
  
  def add_scraped_event(*args)
    CalendarEvent.find_or_create_by_event_title_and_eventstartdate(args[1][0..199], args[4],
        :event_type => 'ce', :event_title => args[1][0..199], :cbody => args[2], :postdate => args[3],
        :eventstartdate => args[4], :eventstarttime => args[5], :eventenddate => args[6], 
        :contentsourceURL => args[0], :location => args[9][0..254],
        :contentsourceID => args[7], :localGMToffset => args[8], :endGMToffset => args[8],
        :subscriptionsourceID => args[7])
  end   
end