class Subscription < KitsTsdModel
	belongs_to :user	   	
	belongs_to :channel, :foreign_key => :channelID, :primary_key => :channelID
	
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
    Channel.joins(:subscriptions).where('subscriptions.user_id = ? and subscriptions.status = ?', uid, 'active')
  end
  
  def self.new_member(usr, channel)
    sub = Subscription.new(:user_id=>usr.id, :channelID => channel.channelID, :contentsourceID => usr.host_profiles[0].subscriptionsourceID )
    sub
  end
  
  def self.find_subscription(uid, cid)
    subscription = Subscription.find_by_user_id_and_channelID(uid, cid)
    subscription.status = 'inactive'
    subscription
  end
end
