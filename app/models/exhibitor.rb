class Exhibitor < KitsTsdModel
  
  has_many :event_exhibitors, :dependent => :destroy
  has_many :events, :through => :event_exhibitors

  has_many :pictures, :as => :imageable, :dependent => :destroy
  has_many :contact_details, :as => :contactable, :dependent => :destroy

  has_many :exhibitor_categories
  has_many :interests, :through => :exhibitor_categories
  accepts_nested_attributes_for :exhibitor_categories, :allow_destroy => true

  accepts_nested_attributes_for :pictures, :allow_destroy => true
  accepts_nested_attributes_for :contact_details, :allow_destroy => true

  scope :unhidden, where(:hide.downcase => 'no')

  def self.active
    unhidden.where(:status.downcase => 'active')
  end

  def self.get_channel_list(ssid)
    where("subscriptionsourceID = ?", ssid)
  end

  def self.get_list(page, cid)
    where("contentsourceID = ?", cid).paginate(:page => page)
  end
  
  def details
    description ? description[0..29] : ''
  end

end
