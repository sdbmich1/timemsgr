class Interest < KitsTsdModel
  attr_accessible :name
	belongs_to :category
#	has_and_belongs_to_many :user
	
	has_many :channel_interests
	has_many :channels, :through => :channel_interests, 
				:conditions => { :status.downcase => 'active'}
	
#	has_attached_file :photo, :styles => { :small => "25x25>" }  
  has_many :events, :through => :channels
    
  scope :unhidden, where(:hide.downcase => 'no')
	default_scope :order => 'sortkey ASC'
  
  def self.get_active_list
    unhidden.where(:status.downcase => 'active')
  end
  
  def self.find_interests(cid)
    get_active_list.where(:category_id => cid)
  end
end
