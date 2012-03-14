require 'open-uri'
require 'nokogiri'
require 'geokit'
module Schedule

  # returns time offset for a given location
  def get_offset(loc) 
    addr = {}  
    res = Geokit::Geocoders::GoogleGeocoder.geocode(loc)
    url = ['http://www.earthtools.org/timezone', res.lat, res.lng].join("/") if res.success    
    doc = Nokogiri::XML(open(url)) if url
    offset = doc.xpath("//offset").text.to_i if doc
    addr = {:city=>res.city, :state=>res.state, :offset=>offset||0, :zip=>res.zip, :country=>res.country} if res.success
  end
end