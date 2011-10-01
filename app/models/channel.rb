class Channel < KitsTsdModel
	attr_accessible :title, :start_date, :location_id, :channel_status
		
	belongs_to :host_profile
  has_many :events,
           :finder_sql => proc { "SELECT e.* FROM kitstsddb.events e " +
           "INNER JOIN channels c ON c.channelID=e.subscriptionsourceID " +
           "WHERE c.id=#{id}" }
  
	has_many :channel_interests, :dependent => :destroy
	has_many :interests, :through => :channel_interests
  has_many :categories, :through => :interests

	has_many :channel_locations, :dependent => :destroy
	has_many :locations, :through => :channel_locations
	
	# define subscriptions
  has_many :subscriptions, :dependent => :destroy
  has_many :users, :through => :subscriptions
	
  scope :active, where(:status.downcase => 'active')
  scope :unhidden, where(:hide.downcase => 'no')
#  scope :uniquelist, :select => 'DISTINCT channels.id, channels.name'
  
  default_scope :order => 'sortkey ASC'
  
  def self.local(loc)
    uniquelist.active.unhidden.joins(:channel_locations).where('channel_locations.location_id = ?', loc)
  end
  
  def self.intlist(loc, int_id)
    local(loc).joins(:channel_interests).where('channel_interests.interest_id in (?)', int_id)
  end
end
