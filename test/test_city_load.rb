def add_city_locations
  include Schedule
  
  ch = LocalChannel.where "channel_name like ?", 'About %'
  ch.each do |channel|
    loc = channel.channel_name.split('About ')[1]
    addr = Schedule.get_offset loc if loc

    if addr    
      cntry = addr[:country] == 'USA'? 'United States' : addr[:country]    
      country = Country.find_by_Description cntry if cntry
      ccode = country.Code if country   
      gmt = GmtTimezone.find_by_code addr[:offset] 
      tzone = gmt.description if gmt
    
      p "#{addr[:city]} | #{addr[:state]} | #{cntry} | #{tzone} | Code #{ccode} | Offset #{addr[:offset]}" if addr[:city] && tzone
    
      # add location
      location = Location.find_or_initialize_by_city(loc)
      p location.city

      if location
        location.country_name = cntry
        location.state, location.time_zone, location.localGMToffset = addr[:state], tzone, addr[:offset]
        location.country_id, location.status, location.hide = ccode, 'active', 'no'         
        location.lat, location.lng = addr[:lat], addr[:lng] if !addr[:city].blank? && tzone
        location.save(false)
      end
    end      
  end
end 