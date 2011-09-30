class HostProfile < KitsTsdModel
  
  belongs_to :user
  has_many :channels,
           :finder_sql => proc { "SELECT c.* FROM channels c " +
           "INNER JOIN host_profiles hp ON c.subscriptionsourceID=hp.subscriptionsourceID " +
           "WHERE hp.id=#{id}" }
  
  has_many :events, :through => :channels 
  
  # define channel relationships
  has_many :subscriptions, :through => :channels, 
          :conditions => { :status => 'active'}
end