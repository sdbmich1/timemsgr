class Presenter < KitsTsdModel
  
  has_many :event_presenters, :dependent => :destroy
  has_many :events, :through => :event_presenters

  has_many :pictures, :as => :imageable, :dependent => :destroy
  has_many :contact_details, :as => :contactable, :dependent => :destroy

  default_scope :order => "name ASC"
  
  def company
    org_name.length > 30 ? org_name[0..29] + '...' : org_name
  end
  
  def occupation
    title.length > 30 ? title[0..29] + '...' : title
  end
end
