class ChannelInterest < KitsTsdModel
	attr_accessible :interest_id, :channel_id
	
	belongs_to :interest
	belongs_to :channel
	
	validates :channel_id, :presence => true
  validates :interest_id, :presence => true, :uniqueness => { :scope => :channel_id }
end
