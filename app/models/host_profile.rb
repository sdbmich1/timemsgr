class HostProfile < KitsTsdModel
  set_table_name 'hostprofiles'
  set_primary_key 'ID'

  attr_accessible :ProfileID, :HostChannelID, :ProfileType, :EntityType, :status,
        :hide, :sortkey, :channelID, :subscriptionsourceID, :subscriptionsourceURL,
        :StartMonth, :StartDay, :StartYear, :HostName, :EntityCategory, :EducationalInst, :PoliticalAffiliation1,
        :Address1, :Address2, :City, :State, :PostalCode, :Phone_Home, :Phone_Work, :Religion, 
        :Phone_cell, :wirelessservice, :Country, :promoCode, :pictures_attributes
                
  text_regex = /^[-\w\,. _\/&@]+$/i
          
  belongs_to :user, :foreign_key => :ProfileID
  has_many :channels, :foreign_key => :HostProfileID
  has_many :local_channels, :foreign_key => :HostProfileID
  
  has_many :events, :through => :channels 
  has_many :scheduled_events, :dependent => :destroy, :primary_key => :subscriptionsourceID, :foreign_key => :contentsourceID do
    def range(sdt)
      where("(eventstartdate >= curdate() and eventstartdate <= ?) OR (eventstartdate <= curdate() and eventenddate BETWEEN curdate() and ?)", sdt, sdt) 
    end
    
    def page(limit=10, offset=0, sdt=Date.today)
      all(:limit=> limit, :offset=>offset).range(sdt)
    end
  end
  
  # used to access friends life schedule of events
  has_many :life_events, :dependent => :destroy, :primary_key => :subscriptionsourceID, :foreign_key => :contentsourceID do
    def private_circle
      where(:allowPrivCircle => 'yes')
    end
    
    def social_circle
      where(:allowSocCircle => 'yes')
    end
    
    def extended_circle
      where(:allowWorldCircle => 'yes')
    end
    
    def show_private_circle
      where(:ShowPrivCircle => 'yes') & LifeEvent.current
    end
    
    def show_social_circle
      where(:ShowSocCircle => 'yes') & LifeEvent.current
    end
    
    def show_extended_circle
      where(:ShowWorldCircle => 'yes') & LifeEvent.current
    end 
    
    def range(sdt)
      where("(eventstartdate >= curdate() and eventstartdate <= ?) OR (eventstartdate <= curdate() and eventenddate BETWEEN curdate() and ?)", sdt, sdt) 
    end
    
    def page(limit=10, offset=0, sdt=Date.today)
      all(:limit=> limit, :offset=>offset).range(sdt)
    end     
  end
  
  # used to access friends private schedule of events
  has_many :private_events, :dependent => :destroy, :primary_key => :subscriptionsourceID, :foreign_key => :contentsourceID do
    def private_circle
      where(:allowPrivCircle => 'yes') 
    end
    
    def social_circle
      where(:allowSocCircle => 'yes')
    end
    
    def extended_circle
      where(:allowWorldCircle => 'yes')
    end
    
    def range(sdt)
      where("(eventstartdate >= curdate() and eventstartdate <= ?) OR (eventstartdate <= curdate() and eventenddate BETWEEN curdate() and ?)", sdt, sdt) 
    end
    
    def page(limit=10, offset=0, sdt=Date.today)
      all(:limit=> limit, :offset=>offset).range(sdt)
    end    
  end
 
  # define channel relationships
  has_many :subscriptions, :through => :channels, :conditions => { :status => 'active'}          
  has_many :pictures, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :pictures, :allow_destroy => true
  
  validates :Phone_cell, :length => {:minimum => 10, :maximum => 12}, :unless => Proc.new {|object| object.Phone_cell.blank?}
  
  def self.get_user(ssid)
    hp = HostProfile.includes(:user).find_by_subscriptionsourceID(ssid) || HostProfile.includes(:user).find_by_ID(ssid)
    hp.user
  end
  
  def ssid
    subscriptionsourceID
  end
  
  def pid
    ProfileID
  end
  
  def self.find_promo_code(pcode, channelID)
    where('LOWER(promoCode) = ? and HostChannelID != ?', pcode.downcase, channelID) rescue nil
  end
  
  def self.create_channel_profile channel_name, channelID, city, pCode
    hp = HostProfile.new
    hp.HostName = hp.Company = channel_name 
    hp.StartMonth, hp.StartDay, hp.StartYear  = Date.today.month, Date.today.day, Date.today.year
    hp.ProfileType, hp.EntityCategory, hp.EntityType, hp.status, hp.hide = 'Provider','provider', 'A', 'active', 'no'       
    hp.promoCode = pCode if pCode
    hp.HostChannelID = hp.subscriptionsourceID = channelID
  
    # get city & state
    loc = Location.nearest_city(city)
    hp.City, hp.State = loc.city, loc.state if loc
    hp.save
        
    hp.id
  end  
          
end