require 'open-uri'
require 'nokogiri'
require 'geokit'
require 'json'
module Schedule

  # returns time offset for a given location
  def self.get_offset(loc) 
    addr = {}  
    res = Geokit::Geocoders::GoogleGeocoder.geocode(loc) rescue nil
    return false unless res
    url = ['http://www.earthtools.org/timezone', res.lat, res.lng].join("/") if res.success    
    doc = Nokogiri::XML(open(url)) if url
    offset = doc.xpath("//offset").text.to_i if doc
    addr = {:city=>res.city, :state=>res.state, :offset=>offset||0, :zip=>res.zip, :country=>res.country, :lat=>res.lat, :lng=>res.lng} if res.success
  end
  
  # use to determine county & city of event based on google api 
  def self.chk_geocode(lat, long)
    url = ['http://maps.googleapis.com/maps/api/geocode/json?latlng=', [lat, long].join(','),'&sensor=false'].join('')
    str = JSON.parse(open(url).read)
    get_county str["results"][0]["address_components"] 
  end
  
  # grabs county name from json hash returned from google api
  def self.get_county(item)
    result = item.detect { |addr| !(addr["types"][0] =~ /level_2/i).nil? }
    result["long_name"] if result
  end
     
end