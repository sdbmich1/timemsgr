class Location < ActiveRecord::Base  
  belongs_to :country
  
  has_many :channel_locations
  has_many :channels, :through => :channel_locations
  
#  has_many :events, :through => :channels
  
  has_many :users
  
  default_scope :order => 'sortkey ASC'
  
  def self.find_location(loc)
    includes(:channels => [:subscriptions]).find(loc)
  end  
  
  def channel_list(pg)
    channels.paginate(:page => pg, :per_page => 15)
  end
  
  def self.active
    where(:status => 'active')
  end
  
  def self.unhidden
    active.where(:hide => 'no')
  end
end
