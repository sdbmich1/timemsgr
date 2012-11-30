class Sponsor < KitsTsdModel
  
  has_many :event_sponsors, :dependent => :destroy
  has_many :events, :through => :event_sponsors

  has_many :pictures, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :pictures, :allow_destroy => true

  has_many :contact_details, :as => :contactable, :dependent => :destroy
  accepts_nested_attributes_for :contact_details, :allow_destroy => true

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

  def descr_length
    description ? description.length : 0
  end
  
end
