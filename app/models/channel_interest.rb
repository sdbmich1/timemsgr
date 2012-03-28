class ChannelInterest < KitsTsdModel
	attr_accessible :interest_id, :channel_id, :category_id
	
	belongs_to :interest
	belongs_to :local_channel, :primary_key => :channel_id, :foreign_key => :channel_id
	belongs_to :category
	
	validates :channel_id, :presence => true
  validates :interest_id, :presence => true, :uniqueness => { :scope => :channel_id }
end
