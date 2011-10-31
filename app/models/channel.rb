class Channel < KitsTsdModel
	attr_accessible :channelID, :status, :hide, :subscriptionsourceID,
	     :channel_name, :channel_title, :HostProfileID, :channel_class,
	     :channel_type
	     
	belongs_to :host_profile, :foreign_key => :HostProfileID
  has_many :events, :foreign_key => :subscriptionsourceID, :primary_key => :channelID,
            :dependent => :destroy
  
	has_many :channel_interests, :dependent => :destroy
	has_many :interests, :through => :channel_interests
  has_many :categories, :through => :interests

  # define user & subscriptions
  has_many :subscriptions, :foreign_key => :channelID, :primary_key => :channelID,
            :dependent => :destroy
  has_many :users, :through => :subscriptions
  
	has_many :channel_locations, :dependent => :destroy
	has_many :locations, :through => :channel_locations,
	:finder_sql => proc { "SELECT e.* FROM kits_development.locations e " +
           "INNER JOIN channel_locations c ON c.location_id=e.id " +
           "WHERE c.id=#{id}" }
	
  has_many :pictures, :as => :imageable, :dependent => :destroy
	
  scope :active, where(:status.downcase => 'active')
  scope :unhidden, where(:hide.downcase => 'no')
#  scope :uniquelist, :select => 'DISTINCT channels.id, channels.name'
  
  default_scope :order => 'sortkey ASC'
  
  def self.local(loc)
    active.unhidden.joins(:channel_locations).where('channel_locations.location_id = ?', loc)
  end
  
  def self.get_list(loc=4, int_id)
    local(loc).joins(:channel_interests).where('channel_interests.interest_id in (?)', int_id)
  end
end
