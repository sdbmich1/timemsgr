class HostProfile < KitsTsdModel
  has_many :channels
  has_many :events, :through => :channels 
end