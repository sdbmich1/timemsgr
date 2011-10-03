class HostProfile < KitsTsdModel
  set_table_name 'hostprofiles'
  set_primary_key 'ID'

  attr_accessible :ProfileID, :HostChannelID, :ProfileType, :EntityType, :status,
        :hide, :sortkey, :channelID, :subscriptionsourceID, :subscriptionsourceURL
  
  belongs_to :user
  has_many :channels,
           :finder_sql => proc { "SELECT c.* FROM channels c " +
           "INNER JOIN hostprofiles hp ON c.channelID=hp.subscriptionsourceID " +
           "WHERE hp.id=#{id}" }
  
  has_many :events, :through => :channels 
  
  # define channel relationships
  has_many :subscriptions, :through => :channels, 
          :conditions => { :status => 'active'}
end