class Presenter < KitsTsdModel
  
  name_regex =  /^[A-Z]'?[- a-zA-Z]+$/i
  text_regex = /^[-\w\. _\/&@]+$/i

  has_many :event_presenters, :dependent => :destroy
  has_many :events, :through => :event_presenters

  has_many :pictures, :as => :imageable, :dependent => :destroy
  has_many :contact_details, :as => :contactable, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => { :scope => [:org_name, :title] }, :format => { :with => name_regex }
  validates :org_name, :presence => true, :format => { :with => text_regex }
  validates :title, :format => { :with => text_regex }
  validates :bio, :presence => true

  default_scope :order => "name ASC"
  
  def company
    org_name.length > 25 ? org_name[0..25] + '...' : org_name
  end

end
