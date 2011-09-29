class ChannelInterest < KitsTsdModel
	attr_accessible :interest_id, :channel_id
	
	belongs_to :interest, :counter_cache => true
	belongs_to :channel, :counter_cache => true
end
