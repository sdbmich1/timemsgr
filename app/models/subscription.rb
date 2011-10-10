class Subscription < KitsTsdModel
	belongs_to :user
	belongs_to :channel
	
	before_create :set_flds
	
  validates :user_id, :presence => true
  validates :channelID, :presence => true, :uniqueness => { :scope => :user_id }  
  validates :contentsourceID, :presence => true

  def set_flds
    self.status = 'active'
    self.hide = 'no'
  end
end
