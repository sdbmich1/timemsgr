require "open-uri"
require "nokogiri"
require 'json'
require 'mechanize'
class ImportAuFeed  
  include Schedule
  
  # add event to system
  def add_event(*args)
#    p 'Add event ' + args[1][0..199]
    new_event = CalendarEvent.new( 
        :event_type => 'ce', :event_title => args[0][0..199],
        :cbody => args[5], 
        :postdate => Time.now,
        :eventstartdate => args[1], :eventstarttime => args[1], :eventenddate => args[2], :eventendtime => args[2],
        :contentsourceURL => args[4][0..99], :location => args[7], :mapplacename => args[7], 
        :contentsourceID => args[3], :localGMToffset => args[6], :endGMToffset => args[6],
        :subscriptionsourceID => args[3]) 
    new_event.save(:validate=>false)
  end  
 
  # process SF State pages
  def read_aussie_feed(feed_url, locale, offset)

    etitle = ''
    loc_str = ' - Eventfinder' 
        
    # get link
    agent = Mechanize.new
    agent.get(feed_url)
    
    # parse the appropriate links
    pages = agent.page.links.select { |l| !(l.href =~ /2013/i).nil? }
    pages.each do |pg|
      
       # open target page
      target_page = pg.click
           
      # parse event id
      str = CGI.parse(pg.href)
      
      unless etitle == target_page.search('title').text
        etitle = target_page.search('title').text
        title = etitle.split(loc_str)[0]
        sdt = target_page.links.select { |l| !(l.href =~ /ics/i).nil? }[0].text rescue nil
        loc = target_page.links.select { |l| !(l.href =~ /venue/i).nil? }[1].text rescue nil
           
        # set event times
        unless sdt.blank?
          sdate = sdt.split(',')[0] + ', ' + Date.today.year.to_s
          stm_left, stm_right = sdt.split(':')[0], sdt.split(':')[1]
          stm = stm_left[-2, stm_left.length] + ':' + stm_right[0,4]
          sdate = (sdate + ' ' + stm).to_datetime
          edt = sdate.advance(:hours=>3)
          
          #p "Event : #{title} | #{sdate} | #{edt} | #{loc}"
        end
          
        # get event details
        details = target_page.search('#description').text rescue nil
        cs_url = pg.href
      
        # find correct channel and location
        cid = LocalChannel.select_channel(title, '', locale).flatten 1
        #cid.map {|channel| p "Channel: #{channel.channelID}" }

        # add event to calendar
        cid.map {|channel| add_event( title[0..199], sdate, edt, channel.channelID, cs_url, details, offset, loc)} if cid
      end
    end 
  end  
  
    # read given file with list of url feeds for a certain city
  def read_feeds(fname, locale, offset)
    File.foreach(fname) {|line| read_aussie_feed(line, locale, offset)}
  end
end