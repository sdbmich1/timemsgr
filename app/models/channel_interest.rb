class ChannelInterest < KitsTsdModel
	attr_accessible :interest_id, :channel_id
	
	belongs_to :interest
	belongs_to :channel
end
