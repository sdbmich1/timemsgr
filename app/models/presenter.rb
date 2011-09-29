class Presenter < KitsTsdModel

  has_many :event_presenters, :dependent => :destroy
  has_many :tsd_events, :through => :event_presenters

  has_many :pictures, :as => :imageable, :dependent => :destroy
  has_many :contact_details, :as => :contactable, :dependent => :destroy

  default_scope :order => "name ASC"
  
  def self.get_event_list(eid)
    joins(:event_presenters).where('event_presenters.event_id = ?', eid)
  end
end
