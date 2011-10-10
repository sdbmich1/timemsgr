class HostProfile < KitsTsdModel
  set_table_name 'hostprofiles'
  set_primary_key 'ID'

  attr_accessible :ProfileID, :HostChannelID, :ProfileType, :EntityType, :status,
        :hide, :sortkey, :channelID, :subscriptionsourceID, :subscriptionsourceURL,
        :StartMonth, :StartDay, :StartYear, :HostName, :EntityCategory
  
  belongs_to :user
  has_many :channels, :foreign_key => :HostProfileID
  
  has_many :events, :through => :channels 
  
  # define channel relationships
  has_many :subscriptions, :through => :channels, 
          :conditions => { :status => 'active'}
          
  has_many :pictures, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :pictures, :allow_destroy => true
          
end