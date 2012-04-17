class Subscription < KitsTsdModel
	belongs_to :user	   	
	belongs_to :channel, :foreign_key => :channelID, :primary_key => :channelID
  belongs_to :local_channel, :foreign_key => :channelID, :primary_key => :channelID
	
	before_create :set_flds
	
	attr_accessible :status, :user_id, :channelID, :contentsourceID, :hide, :channel_id
	
  validates :user_id, :presence => true
  validates :channelID, :presence => true #, :uniqueness => { :scope => :user_id }  
  validates :contentsourceID, :presence => true
  
  scope :active, where(:status.downcase => 'active')
  scope :unhidden, where(:hide.downcase => 'no')

  def set_flds
    self.status = 'active'
    self.hide = 'no'
  end
  
  def self.get_active_list(uid)
    LocalChannel.joins(:subscriptions).where('subscriptions.user_id = ? and subscriptions.status = ?', uid, 'active')
  end
  
  def self.new_member(usr, channel)
    sub = Subscription.find_or_initialize_by_user_id_and_channelID(:user_id=>usr.id, :channelID => channel.channelID, :contentsourceID => usr.ssid )
    sub.status = 'active'
    sub
  end
  
  def self.unsubscribe(uid, cid)
    subscription = Subscription.find_by_user_id_and_channelID(uid, cid) rescue nil
    subscription.status = 'inactive' if subscription
    subscription
  end
  
  def get_channel_name(cid)
    channel = LocalChannel.find_by_channelID(cid)
    channel.channel_name if channel
  end
  
  def channel_name
    channel = LocalChannel.find_by_channelID self.channelID
    channel.channel_name if channel
  end
  
  def events
    local_channel.calendar_events
  end
end
