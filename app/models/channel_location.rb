class ChannelLocation < KitsTsdModel
  belongs_to :channel
  belongs_to :location
  
  validates :channel_id, :presence => true
  validates :location_id, :presence => true, :uniqueness => { :scope => :channel_id }
end
