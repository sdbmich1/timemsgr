class SponsorPage < KitsTsdModel
  belongs_to :event, :foreign_key => :subscriptionsourceID, :primary_key => :subscriptionsourceID
  has_many :sponsors, :as => :sponsorable, :dependent => :destroy

  default_scope :order => 'name ASC'
  scope :unhidden, where(:hide.downcase => 'no')

  def self.active
    unhidden.where(:status.downcase => 'active')
  end

  def self.get_page_list(ssid)
    active.where("subscriptionsourceID = ?", ssid)
  end

end
