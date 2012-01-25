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
            :dependent => :destroy, :conditions => "status = 'active'"
  has_many :users, :through => :subscriptions
  
	has_many :channel_locations, :dependent => :destroy
	has_many :locations, :through => :channel_locations,
	:finder_sql => proc { "SELECT l.* FROM #{dbname}.locations l " +
           "INNER JOIN channel_locations c ON c.location_id=l.id " +
           "WHERE c.id=#{id}" }
	
  has_many :pictures, :as => :imageable, :dependent => :destroy
	
  scope :active, where(:status.downcase => 'active')
  scope :unhidden, where(:hide.downcase => 'no')
#  scope :uniquelist, :select => 'DISTINCT channels.id, channels.name'
  
  default_scope :order => 'sortkey ASC'
  
  def self.dbname
    Rails.env.development? ? "`kits_development`" : "`kits_production`"
  end 
  
  def self.local(loc)
    active.unhidden.joins(:channel_locations).where("channel_locations.location_id = ?", loc)
  end
  
  def self.get_list(loc=4, int_id)
    local(loc).joins(:channel_interests).where('channel_interests.interest_id in (?)', int_id)
  end
  
  def self.get_interests(loc, int_id)
    find_by_sql(["#{getSQL}", loc, int_id])
  end
  
  def self.channel_cached(loc, int_id)
    Rails.cache.fetch("get_channels") do 
      channels = get_interests(loc, int_id)
      preload_associations(channels, [:pictures, :subscriptions])
      return channels
    end 
  end
  
  def self.delete_cached
    Rails.cache.delete('get_channels')
    Rails.cache.delete('channel_list')
  end
  
  def self.find_channel(cid)
    includes(:pictures, {:subscriptions => [{:user=>[:pictures, {:host_profiles=>[:scheduled_events, :private_events]}]}]}).find(cid)
  end  
  
  def self.getSQL
    "(SELECT c.* FROM `kitsknndb`.channels c 
    INNER JOIN #{dbname}.channel_locations cl ON cl.channel_id = c.id 
    INNER JOIN #{dbname}.locations l ON cl.location_id=l.id
    INNER JOIN `kitsknndb`.channel_interests i ON i.channel_id = c.id 
    WHERE c.status = 'active' AND c.hide = 'no' 
    AND (cl.location_id = ?) 
    AND (i.interest_id in (?))) ORDER BY sortkey ASC"
  end
  
  def summary
    bbody.blank? ? '' : bbody[0..59] 
  end
  
  def ssid
    subscriptionsourceID
  end
  
  def self.channel_list(loc, int_id, pg)
    paginate_by_sql(["#{getSQL}", loc, int_id], :page => pg, :per_page => 15 )
  end

  def self.list_cached(loc, int_id, pg)
    Rails.cache.fetch("channel_list") do 
      channels = channel_list(loc, int_id, pg)
      preload_associations(channels, [:pictures, :subscriptions])
      return channels
    end 
  end
    
  define_index do
    indexes :channel_name, :sortable => true
    indexes :bbody
    indexes :cbody
    indexes channel_locations(:location_id), :as => :location_id
   
    has :id, :as => :channel_id
    where "(status = 'active' AND hide = 'no') "
  end    

end
