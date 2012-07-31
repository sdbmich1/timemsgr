class Location < ActiveRecord::Base
  include Schedule 
  acts_as_mappable :distance_field_name => :distance
  belongs_to :country
  
  attr_accessible :lat, :lng, :city, :state, :status, :country_name, :time_zone, :localGMToffset, :hide, :country_id, :sortkey
  
  has_many :channel_locations
  has_many :channels, :through => :channel_locations
  
#  has_many :events, :through => :channels
  
  has_many :users
  
  default_scope :order => 'city ASC'
  
  def self.find_location(loc)
    includes(:channels => [:subscriptions]).find(loc)
  end  
  
  def self.channel_list(pg)
    channels.paginate(:page => pg, :per_page => 15)
  end
  
  def self.active
    where(:status => 'active')
  end
  
  def self.unhidden
    active.where(:hide => 'no')
  end
  
  def self.nearest_city loc
    Location.within(40, :origin => loc).sort_by { |e| e.distance }.first 
  end
  
  def self.nearest_city_by_ip ip
    location = Geokit::Geocoders::IpGeocoder.geocode(ip)
    location.present? ? nearest_city([location.city, location.state].join(', ')) : nil
  end  
end
