class Interest < KitsTsdModel
  before_save :set_flds
  attr_accessible :name, :hide, :status, :category_id, :id, :sortkey
	belongs_to :category

	has_many :user_interests
	has_many :users, :through => :user_interests
		
	has_many :channel_interests
	has_many :channels, :through => :channel_interests, 
				:conditions => { :status.downcase => 'active'}
	
  has_many :events, :through => :channels
    
  scope :unhidden, where(:hide.downcase => 'no')
	default_scope :order => 'sortkey ASC'
  
  def self.get_active_list
    unhidden.where(:status.downcase => 'active')
  end
  
  def self.find_interests(cid)
    get_active_list.where(:category_id => cid)
  end
  
  def self.find_or_add_interest title
    category = Category.select_category(title).first  
    interest = Interest.find_or_create_by_name title, :category_id => category[0].id, :sortkey => category[0].interests.count+1
    interest
  end
  
  def self.get_interest_by_name(title)
    if interest = Interest.where("name like ?", '%' + title + '%').first
      interest
    else 
      interest = Interest.add_interest title
    end  
  end 
  
  def set_flds
    self.hide, self.status = "no", "active"
  end 
end
